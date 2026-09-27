import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardOpenOption

fun main() {
    val file = Path.of("notes.txt")

    while (true) {
        println("\n1 tambah | 2 lihat | 3 keluar")
        print("pilih: ")
        when (readlnOrNull()?.trim()) {
            "1" -> {
                print("isi catatan: ")
                val isi = readlnOrNull()?.trim().orEmpty()
                if (isi.isEmpty()) { println("kosong, batal."); continue }
                Files.writeString(file, isi + "\n", StandardOpenOption.CREATE, StandardOpenOption.APPEND)
                println("kesimpan!")
            }
            "2" -> {
                if (!Files.exists(file)) { println("(belum ada catatan)"); continue }
                Files.readAllLines(file).forEachIndexed { i, baris -> println("${i + 1}. $baris") }
            }
            "3" -> break
            else -> println("ketik 1 / 2 / 3 aja.")
        }
    }
}
// ponytail: simpan txt-append saja (ceiling: 1 user, tanpa edit/hapus/cari); upgrade ke SQLite saat butuh itu.
