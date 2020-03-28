## Petunjuk penggunaan program
* compile :   
<code>make all</code>

* run program :   
<code>make run N=jumlah_node BLOCKSIZE=jumlah_thread</code>

## Pembagian Kerja
* 13517093 : Paralel dijkstra, makefile, testing di server, laporan
* 13517120 : Paralel dijkstra, input, output file, testing di server, laporan 

## Solusi Paralel
Untuk mengimplementasikan algoritma shortest-path dijkstra secara paralel dari setiap node sumber ke semua node lain, solusi yang kami buat adalah dengan memparalelkan proses dijkstra untuk setiap node. Sehingga setiap thread bertanggungjawab untuk menghitung dijkstra shortest-path dari node sumber yang dialokasikan untuknya ke semua node lain.  

Sebagai contoh, 
* Jika terdapat 32 node dan 32 thread, maka proses thread ke 1 (threadIdx.x (1)) bertanggungjawab menghitung dijkstra shortest path dari sumber node 1 ke semua node lainnya, thread ke 2 (threadIdx.x (2)) menghitung dari sumber node  2 ke semua node lainnya dan seterusnya.
* Dijkstra yang sudah dihitung pada masing masing thread, solusinya akan dituliskan kedalam array hasil_gabung yang menyimpan solusi global dari semua path terpendek
* Kemudian CPU menunggu hingga kernel selesai mengakses hasil akhirnya dengan memanggil cudaDeviceSynchronize()

## Analisis solusi
Terdapat solusi dijkstra yang lebih baik dari solusi yang kami ajukan. 
Solusi tersebut adalah yang diparalelkan adalah proses dijkstranya bukan node sumbernya.
Setiap proses akan mengirimkan hasil perhitungan dijkstra pada lokal nodenya lalu digabungkan menjadi satu.
Dijkstra dilakukan sebanyak n kali sesuai dengan jumlah node. Dengan mempararelkan proses dijkstra menurut kami akan menghasilkan solusi yang lebih baik.

## Jumlah Thread
Jumlah thread yang optimal adalah sebanyak jumlah maksimal thread dalam satu block. Dalam kasus server, jumlah maksimum thread per block sebanyak 1024 sesuai dengan spesifikasi GPU, sehingga kami memilih menggunakan 1024 sebagai jumlah threadnya. Adapun untuk kasus 100 node ternyata hasil paralel lebih lambat dibanding dengan serial, menurut analisis kami, hal ini dapat terjadi karena jumlah thread yang kami gunakan sebanyak 1024 padahal pada kenyatannya hanya dibutuhkan 100 thread untuk melakukan perhitungan dijkstra sehingga sebahanyak (1024 - 100 = 924 proses) menjadi sia-sia dan memperlambat kinerja keseluruhan proses.

## Pengukuran kinerja
| Banyak Node | Paralel | Serial |
| ------ | ------ | ------ |
| 100         | 31155, 31352, 31453       | 14788, 17678, 16938 |
| 500         | 661025, 658752, 665986    | 1216404, 1231011, 1342385  |
| 1000        | 3016924, 3015812, 3040653 | 8522398, 8538920, 8452119  |
| 3000        | 28249127, 34421236, 33592223 | 239282393, 245265219, 249323108 |

## Analisis kinerja
Kinerja pada proses parallel berjalan lebih cepat dari serial untuk hampir semua kasus. Dari 18 percobaan yang kami lakukan, semua proses parallel berjalan lebih cepat dari proses serial, kecuali pada kasus 100 node. Hal ini seperti penjelasan sebelumya, terjadi karena kami memilih menggunakan 1024 sebagai jumlah threadnya, sehingga sebanyak (1024 - 100 = 924 proses) menjadi sia-sia dan memperlambat kinerja keseluruhan proses untuk pengujian tersebut.

