# Announcement

Beberapa file yang harus ada dalam repositori tersebut diantaranya:
* Direktori src yang berisi source code yang anda buat.
* File output yang berisi hasil uji dijkstra algorithm pada data uji.
* Makefile. Buatlah sehingga kompilasi program dapat dilakukan hanya dengan pemanggilan command ’make’ saja.
* File README.md yang berisi:
    * Petunjuk penggunaan program.
    * Pembagian tugas. Sampaikan dalam list pengerjaan untuk setiap mahasiswa. Sebagai contoh: XXXX mengerjakan fungsi YYYY, ZZZZ, dan YYZZ.
    * Laporan pengerjaan, dengan struktur laporan sesuai dengan deskripsi pada bagian sebelumnya.

Deskripsi solusi paralel. Berikan ilustrasi jika perlu.
Analisis solusi yang anda berikan. Apakah mungkin terdapat solusi yang memberikan kinerja lebih baik?
Jumlah thread yang digunakan. Kenapa anda memilih angka tersebut?
Pengukuran kinerja untuk tiap kasus uji (jumlah N pada graf) dibandingkan dengan dijkstra algorithm serial.
Analisis perbandingan kinerja serial dan paralel. Analisis yang diharapkan adalah analisis yang minimal dapat menjelaskan setiap hasil pengukuran kinerja sebelumnya. 


## Solusi Paralel
Untuk mengimplementasikan algoritma shortest-path dijkstra secara paralel dari setiap node sumber ke semua node lain, solusi yang kami buat adalah dengan memparalelkan proses dijkstra untuk setiap node. Sehingga setiap thread bertanggungjawab untuk menghitung dijkstra shortest-path dari node sumber yang dialokasikan untuknya ke semua node lain.  

Sebagai contoh, 
* Jika terdapat 32 node dan 32 thread, maka proses thread ke 1 (threadIdx.x (1)) bertanggungjawab menghitung dijkstra shortest path dari sumber node 1 ke semua node lainnya, thread ke 2 (threadIdx.x (2)) menghitung dari sumber node  2 ke semua node lainnya dan seterusnya.
* Dijkstra yang sudah dihitung pada masing masing proses, solusinya akan dituliskan kedalam array hasil_gabung yang menyimpan solusi global dari semua path terpendek
* Proses dengan id thread = 0 akan menggabungkan seluruh hasil dijkstra pada semua proses

## Analisis solusi
Terdapat solusi dijkstra yang lebih baik dari solusi yang kami ajukan. 
Pada solusi ini, setiap kali perhitungan dijkstra akan dilakukan secara parallel dengan membagi node ke beberapa proses.
Setiap proses akan mengirimkan hasil perhitungan dijkstra pada lokal nodenya lalu digabungkan menjadi satu.
Dijkstra dilakukan sebanyak n kali sesuai dengan jumlah node. 

## Jumlah Thread
Jumlah thread yang optimal adalah sebanyak jumlah maksimal thread yang dapat digunakan. Dalam kasus server, core berjumlah 2 dan thread percore hanya 1 maka digunakan thread sebesar 2 * 1 = 2.

## Pengukuran kinerja
| Banyak Node | Paralel | Serial |
| ------ | ------ | ------ |
| 100         | 5522, 5328, 4897   | 9335, 8937, 12927 |
| 500         | 431817, 450030, 439047    | 870074, 867214, 873625  |
| 1000        | 3415605, 3394692, 34129201 | 6820814, 6844427, 6951209 |
| 3000        | 94708422, 96494819, 94662311 | 191622396, 191622396, 191607321|

## Analisis kinerja
Kinerja pada proses parallel berjalan lebih cepat dari serial. Dari 18 percobaan yang kami lakukan, semua proses parallel berjalan lebih cepat dari proses serial.

## Pembagian Kerja