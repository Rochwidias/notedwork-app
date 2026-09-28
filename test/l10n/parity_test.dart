import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const String idArbPath = 'lib/l10n/app_id.arb';
const String enArbPath = 'lib/l10n/app_en.arb';

Map<String, dynamic> readArb(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError(
      'Missing ARB file "$path". Tests must run from the project root.',
    );
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Set<String> messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

Set<String> placeholdersFromText(String message) => RegExp(r'\{(\w+)\}')
    .allMatches(message)
    .map((m) => m.group(1)!)
    .toSet();

Set<String> placeholdersFromMeta(Map<String, dynamic> arb, String key) {
  final meta = arb['@$key'];
  if (meta is! Map<String, dynamic>) return <String>{};
  final placeholders = meta['placeholders'];
  if (placeholders is! Map<String, dynamic>) return <String>{};
  return placeholders.keys.toSet();
}

void main() {
  final Map<String, dynamic> id = readArb(idArbPath);
  final Map<String, dynamic> en = readArb(enArbPath);
  final Set<String> idKeys = messageKeys(id);
  final Set<String> enKeys = messageKeys(en);

  test('app_id.arb and app_en.arb have identical key sets', () {
    final List<String> missingInEn = idKeys.difference(enKeys).toList()..sort();
    final List<String> missingInId = enKeys.difference(idKeys).toList()..sort();
    final List<String> errors = <String>[];
    if (missingInEn.isNotEmpty) {
      errors.add(
        'Keys in $idArbPath but missing from $enArbPath '
        '(${missingInEn.length}): $missingInEn',
      );
    }
    if (missingInId.isNotEmpty) {
      errors.add(
        'Keys in $enArbPath but missing from $idArbPath '
        '(${missingInId.length}): $missingInId',
      );
    }
    expect(
      errors,
      isEmpty,
      reason: 'ARB key parity failed:\n${errors.join('\n')}',
    );
  });

  test('interpolated placeholder names match across locales and metadata', () {
    final List<String> errors = <String>[];
    final Iterable<String> keysWithPlaceholders = idKeys.where((key) {
      if (!enKeys.contains(key)) return false;
      final String idValue = id[key] as String;
      final String enValue = en[key] as String;
      return placeholdersFromText(idValue).isNotEmpty ||
          placeholdersFromText(enValue).isNotEmpty;
    });
    for (final String key in keysWithPlaceholders) {
      final Set<String> idText = placeholdersFromText(id[key] as String);
      final Set<String> enText = placeholdersFromText(en[key] as String);
      final Set<String> idMeta = placeholdersFromMeta(id, key);
      final Set<String> enMeta = placeholdersFromMeta(en, key);

      if (!_setEquals(idText, enText)) {
        errors.add(
          'Placeholder mismatch for "$key": id text=$idText, en text=$enText',
        );
      }
      if (!_setEquals(idText, idMeta)) {
        errors.add(
          'Metadata mismatch for "$key" in $idArbPath: '
          'text=$idText, @metadata=$idMeta',
        );
      }
      if (!_setEquals(enText, enMeta)) {
        errors.add(
          'Metadata mismatch for "$key" in $enArbPath: '
          'text=$enText, @metadata=$enMeta',
        );
      }
    }
    expect(
      errors,
      isEmpty,
      reason: 'Placeholder parity failed:\n${errors.join('\n')}',
    );
  });

  test('no message has an empty value', () {
    final List<String> errors = <String>[];
    for (final MapEntry<String, dynamic> entry in id.entries) {
      if (entry.key.startsWith('@')) continue;
      final Object? value = entry.value;
      if (value is! String || value.isEmpty) {
        errors.add('${entry.key} in $idArbPath -> ${jsonEncode(value)}');
      }
    }
    for (final MapEntry<String, dynamic> entry in en.entries) {
      if (entry.key.startsWith('@')) continue;
      final Object? value = entry.value;
      if (value is! String || value.isEmpty) {
        errors.add('${entry.key} in $enArbPath -> ${jsonEncode(value)}');
      }
    }
    expect(
      errors,
      isEmpty,
      reason: 'Empty ARB values found:\n${errors.join('\n')}',
    );
  });
}

bool _setEquals(Set<String> a, Set<String> b) {
  if (a.length != b.length) return false;
  return a.containsAll(b);
}
