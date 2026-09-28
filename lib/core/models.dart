// Domain types — port of the web app's `lib/types.ts`.
// Pure Dart (no Flutter import) so storage, logic, and tests can share them.

/// Bahasa tampilan — web: `type Lang = "id" | "en"`.
enum Lang { id, en }

/// Prioritas tugas — web: `type Prio = "tinggi" | "sedang" | "rendah"`.
///
/// Identifier memakai nama Inggris, tetapi [key] menyimpan nilai wire
/// Indonesia apa adanya supaya data JSON/Hive lama tetap terbaca.
enum Prio {
  high('tinggi'),
  medium('sedang'),
  low('rendah');

  const Prio(this.key);

  /// Nilai persis seperti di web (`"tinggi" | "sedang" | "rendah"`).
  final String key;

  /// Parsing longgar; nilai tak dikenal/kosong jatuh ke [Prio.medium]
  /// — web: `task.prio in PRIO ? task.prio : "sedang"`.
  static Prio fromKey(String? key) =>
      Prio.values.firstWhere((p) => p.key == key, orElse: () => Prio.medium);
}

/// Layar utama — web: `type ViewName`.
enum ViewName { beranda, email, tugas, kalender, catatan, settings }

/// Target navigasi — web: `type NavTarget = ViewName | "tambah"`.
enum NavTarget {
  beranda,
  email,
  tugas,
  kalender,
  catatan,
  settings,
  tambah;

  /// Dari view biasa; [ViewName] tidak punya padanan "tambah".
  static NavTarget fromView(ViewName view) => switch (view) {
    ViewName.beranda => NavTarget.beranda,
    ViewName.email => NavTarget.email,
    ViewName.tugas => NavTarget.tugas,
    ViewName.kalender => NavTarget.kalender,
    ViewName.catatan => NavTarget.catatan,
    ViewName.settings => NavTarget.settings,
  };

  /// `null` untuk [NavTarget.tambah] (buka sheet, bukan pindah view).
  ViewName? get view => switch (this) {
    NavTarget.tambah => null,
    NavTarget.beranda => ViewName.beranda,
    NavTarget.email => ViewName.email,
    NavTarget.tugas => ViewName.tugas,
    NavTarget.kalender => ViewName.kalender,
    NavTarget.catatan => ViewName.catatan,
    NavTarget.settings => ViewName.settings,
  };
}

/// Tema — web: `type Theme = "dark" | "light" | "auto"`.
/// Sengaja dinamai `AppTheme` agar tidak bentrok dengan `Theme` milik Flutter.
enum AppTheme { dark, light, auto }

/// Lampiran email — web: `MailFile`.
class MailFile {
  const MailFile({required this.name, required this.size});

  factory MailFile.fromJson(Map<String, dynamic> json) => MailFile(
    name: json['name'] as String? ?? '',
    size: json['size'] as String? ?? '',
  );

  final String name;
  final String size;

  MailFile copyWith({String? name, String? size}) =>
      MailFile(name: name ?? this.name, size: size ?? this.size);

  Map<String, dynamic> toJson() => {'name': name, 'size': size};

  @override
  bool operator ==(Object other) =>
      other is MailFile && other.name == name && other.size == size;

  @override
  int get hashCode => Object.hash(name, size);
}

/// Email — web: `Mail` (unread/starred ikut label Gmail, opsional).
class Mail {
  const Mail({
    required this.id,
    required this.from,
    required this.email,
    required this.subj,
    required this.prev,
    required this.body,
    required this.time,
    required this.tag,
    this.files = const [],
    this.unread,
    this.starred,
  });

  factory Mail.fromJson(Map<String, dynamic> json) => Mail(
    id: json['id'] as String? ?? '',
    from: json['from'] as String? ?? '',
    email: json['email'] as String? ?? '',
    subj: json['subj'] as String? ?? '',
    prev: json['prev'] as String? ?? '',
    body: json['body'] as String? ?? '',
    time: json['time'] as String? ?? '',
    tag: json['tag'] as String? ?? '',
    files: (json['files'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(MailFile.fromJson)
        .toList(),
    unread: json['unread'] as bool?,
    starred: json['starred'] as bool?,
  );

  final String id;
  final String from;
  final String email;
  final String subj;
  final String prev;
  final String body;
  final String time;
  final String tag;
  final List<MailFile> files;

  /// Status UNREAD langsung dari label Gmail (`null` = tidak diketahui).
  final bool? unread;

  /// Bintang Gmail (label STARRED) — boolean, bukan substring di tag.
  final bool? starred;

  Mail copyWith({
    String? id,
    String? from,
    String? email,
    String? subj,
    String? prev,
    String? body,
    String? time,
    String? tag,
    List<MailFile>? files,
    Object? unread = _unset,
    Object? starred = _unset,
  }) => Mail(
    id: id ?? this.id,
    from: from ?? this.from,
    email: email ?? this.email,
    subj: subj ?? this.subj,
    prev: prev ?? this.prev,
    body: body ?? this.body,
    time: time ?? this.time,
    tag: tag ?? this.tag,
    files: files ?? this.files,
    unread: identical(unread, _unset) ? this.unread : unread as bool?,
    starred: identical(starred, _unset) ? this.starred : starred as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'from': from,
    'email': email,
    'subj': subj,
    'prev': prev,
    'body': body,
    'time': time,
    'tag': tag,
    'files': files.map((f) => f.toJson()).toList(),
    if (unread != null) 'unread': unread,
    if (starred != null) 'starred': starred,
  };

  @override
  bool operator ==(Object other) =>
      other is Mail &&
      other.id == id &&
      other.from == from &&
      other.email == email &&
      other.subj == subj &&
      other.prev == prev &&
      other.body == body &&
      other.time == time &&
      other.tag == tag &&
      other.files.length == files.length &&
      other.unread == unread &&
      other.starred == starred;

  @override
  int get hashCode => Object.hash(
    id,
    from,
    email,
    subj,
    prev,
    body,
    time,
    tag,
    Object.hashAll(files),
    unread,
    starred,
  );
}

/// Acara kalender — web: `Sched`.
class Sched {
  const Sched({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.endTime,
    this.allDay,
    this.overnight,
    required this.note,
    required this.color,
    this.reminderMin,
  });

  factory Sched.fromJson(Map<String, dynamic> json) => Sched(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    date: json['date'] as String? ?? '',
    time: json['time'] as String? ?? '',
    endTime: json['endTime'] as String?,
    allDay: json['allDay'] as bool?,
    overnight: json['overnight'] as bool?,
    note: json['note'] as String? ?? '',
    color: json['color'] as String? ?? '',
    reminderMin: (json['reminderMin'] as num?)?.toInt(),
  );

  final String id;
  final String title;

  /// yyyy-mm-dd.
  final String date;

  /// hh:mm mulai.
  final String time;

  /// hh:mm selesai, same-day, opsional — kosong = sekilas (end == start).
  final String? endTime;

  /// Seharian dari Google Calendar (start.date tanpa dateTime).
  final bool? allDay;

  /// Jam selesai lewat tengah malam (end <= start → tanggal end +1 hari).
  final bool? overnight;

  final String note;
  final String color;

  /// Menit pengingat sebelum mulai; opsional, default 180, 0 = mati.
  final int? reminderMin;

  Sched copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    Object? endTime = _unset,
    Object? allDay = _unset,
    Object? overnight = _unset,
    String? note,
    String? color,
    Object? reminderMin = _unset,
  }) => Sched(
    id: id ?? this.id,
    title: title ?? this.title,
    date: date ?? this.date,
    time: time ?? this.time,
    endTime: identical(endTime, _unset) ? this.endTime : endTime as String?,
    allDay: identical(allDay, _unset) ? this.allDay : allDay as bool?,
    overnight: identical(overnight, _unset)
        ? this.overnight
        : overnight as bool?,
    note: note ?? this.note,
    color: color ?? this.color,
    reminderMin: identical(reminderMin, _unset)
        ? this.reminderMin
        : reminderMin as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'time': time,
    if (endTime != null) 'endTime': endTime,
    if (allDay != null) 'allDay': allDay,
    if (overnight != null) 'overnight': overnight,
    'note': note,
    'color': color,
    if (reminderMin != null) 'reminderMin': reminderMin,
  };

  @override
  bool operator ==(Object other) =>
      other is Sched &&
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.time == time &&
      other.endTime == endTime &&
      other.allDay == allDay &&
      other.overnight == overnight &&
      other.note == note &&
      other.color == color &&
      other.reminderMin == reminderMin;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    date,
    time,
    endTime,
    allDay,
    overnight,
    note,
    color,
    reminderMin,
  );
}

/// Jadwal kuliah mingguan — web: `Routine`.
class Routine {
  const Routine({
    required this.id,
    required this.course,
    required this.day,
    required this.start,
    required this.end,
    required this.room,
    required this.lect,
    required this.color,
  });

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    id: json['id'] as String? ?? '',
    course: json['course'] as String? ?? '',
    day: (json['day'] as num?)?.toInt() ?? 1,
    start: json['start'] as String? ?? '',
    end: json['end'] as String? ?? '',
    room: json['room'] as String? ?? '',
    lect: json['lect'] as String? ?? '',
    color: json['color'] as String? ?? '',
  );

  final String id;
  final String course;

  /// 1=Senin … 7=Minggu.
  final int day;
  final String start;
  final String end;
  final String room;
  final String lect;
  final String color;

  Routine copyWith({
    String? id,
    String? course,
    int? day,
    String? start,
    String? end,
    String? room,
    String? lect,
    String? color,
  }) => Routine(
    id: id ?? this.id,
    course: course ?? this.course,
    day: day ?? this.day,
    start: start ?? this.start,
    end: end ?? this.end,
    room: room ?? this.room,
    lect: lect ?? this.lect,
    color: color ?? this.color,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'course': course,
    'day': day,
    'start': start,
    'end': end,
    'room': room,
    'lect': lect,
    'color': color,
  };

  @override
  bool operator ==(Object other) =>
      other is Routine &&
      other.id == id &&
      other.course == course &&
      other.day == day &&
      other.start == start &&
      other.end == end &&
      other.room == room &&
      other.lect == lect &&
      other.color == color;

  @override
  int get hashCode =>
      Object.hash(id, course, day, start, end, room, lect, color);
}

/// Tugas kuliah — web: `Task`.
class Task {
  const Task({
    required this.id,
    required this.matkul,
    required this.title,
    required this.date,
    required this.time,
    required this.prio,
    required this.note,
    required this.done,
    this.reminderMin,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String? ?? '',
    matkul: json['matkul'] as String? ?? '',
    title: json['title'] as String? ?? '',
    date: json['date'] as String? ?? '',
    time: json['time'] as String? ?? '',
    prio: Prio.fromKey(json['prio'] as String?),
    note: json['note'] as String? ?? '',
    done: json['done'] as bool? ?? false,
    reminderMin: (json['reminderMin'] as num?)?.toInt(),
  );

  final String id;
  final String matkul;
  final String title;

  /// yyyy-mm-dd.
  final String date;

  /// hh:mm; kosong = akhir hari (23:59), konsisten dengan badge/isOverdue.
  final String time;
  final Prio prio;
  final String note;
  final bool done;

  /// Menit pengingat sebelum deadline; opsional, default 180, 0 = mati.
  final int? reminderMin;

  Task copyWith({
    String? id,
    String? matkul,
    String? title,
    String? date,
    String? time,
    Prio? prio,
    String? note,
    bool? done,
    Object? reminderMin = _unset,
  }) => Task(
    id: id ?? this.id,
    matkul: matkul ?? this.matkul,
    title: title ?? this.title,
    date: date ?? this.date,
    time: time ?? this.time,
    prio: prio ?? this.prio,
    note: note ?? this.note,
    done: done ?? this.done,
    reminderMin: identical(reminderMin, _unset)
        ? this.reminderMin
        : reminderMin as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'matkul': matkul,
    'title': title,
    'date': date,
    'time': time,
    'prio': prio.key,
    'note': note,
    'done': done,
    if (reminderMin != null) 'reminderMin': reminderMin,
  };

  @override
  bool operator ==(Object other) =>
      other is Task &&
      other.id == id &&
      other.matkul == matkul &&
      other.title == title &&
      other.date == date &&
      other.time == time &&
      other.prio == prio &&
      other.note == note &&
      other.done == done &&
      other.reminderMin == reminderMin;

  @override
  int get hashCode => Object.hash(
    id,
    matkul,
    title,
    date,
    time,
    prio,
    note,
    done,
    reminderMin,
  );
}

/// Catatan — web: `Note`.
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    this.driveFileId,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    driveFileId: json['driveFileId'] as String?,
  );

  final String id;
  final String title;
  final String body;

  /// Epoch ms terakhir diubah; untuk urutan terbaru dulu.
  final int updatedAt;

  /// ID file Google Docs di Drive (hasil sync); absen = belum tersync.
  final String? driveFileId;

  Note copyWith({
    String? id,
    String? title,
    String? body,
    int? updatedAt,
    Object? driveFileId = _unset,
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    updatedAt: updatedAt ?? this.updatedAt,
    driveFileId: identical(driveFileId, _unset)
        ? this.driveFileId
        : driveFileId as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'updatedAt': updatedAt,
    if (driveFileId != null) 'driveFileId': driveFileId,
  };

  @override
  bool operator ==(Object other) =>
      other is Note &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      other.updatedAt == updatedAt &&
      other.driveFileId == driveFileId;

  @override
  int get hashCode =>
      Object.hash(id, title, body, updatedAt, driveFileId);
}

/// Preset balas/kirim email — web: `ComposePreset`.
class ComposePreset {
  const ComposePreset({
    required this.to,
    required this.subj,
    required this.body,
  });

  factory ComposePreset.fromJson(Map<String, dynamic> json) => ComposePreset(
    to: json['to'] as String? ?? '',
    subj: json['subj'] as String? ?? '',
    body: json['body'] as String? ?? '',
  );

  final String to;
  final String subj;
  final String body;

  ComposePreset copyWith({String? to, String? subj, String? body}) =>
      ComposePreset(
        to: to ?? this.to,
        subj: subj ?? this.subj,
        body: body ?? this.body,
      );

  Map<String, dynamic> toJson() => {'to': to, 'subj': subj, 'body': body};

  @override
  bool operator ==(Object other) =>
      other is ComposePreset &&
      other.to == to &&
      other.subj == subj &&
      other.body == body;

  @override
  int get hashCode => Object.hash(to, subj, body);
}

/// Penanda "tidak diisi" agar `copyWith` bisa mengosongkan field opsional.
const Object _unset = Object();
