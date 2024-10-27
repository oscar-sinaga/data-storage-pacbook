# Data Storage Pacbook

## Bahasa Indonesia

## Pendahuluan

### Deskripsi

Pacbook adalah perusahaan fiksi yang bergerak dalam penjualan berbagai jenis buku. Mereka sudah mempunyai database sehingga bisa menangani perubahan data seperti aktivitas transaksi, penambahan pelanggan, buku, pengurangan katalog buku dan lain-lain. Database ini juga sebenarnya sudah bisa digunakan untuk analisis business perusahaan.

### Permasalahan

Meskipun mereka sudah mempunyai database, tetapi database ini sebenarnya fokus dalam menangani perubahan data transaksi seperti penambahan atau perubahan data pelanggan ataupun buku. Database ini kurang efektif jika digunakan untuk analisis karena susah dipahami user, dan tidak ada rekaman perubahan pada atribut dimensi, seperti perubahan alamat pelanggan atau status pekerjaan. Oleh karena itu user membutuhkan database terpisah (data warehouse) yang digunakan fokus untuk analytics dan dapat merekam perubahan yang terjadi secara periodic.

### Requirements Gathering

Ada beberapa metrik analytics yang user atau stakeholders akan explore pada datawarehouse analytics yang sudah dibuat :

1. Tren Penjualan Bulanan
2. Daftar buku dan total kuantitas penjualan mereka seiring waktu.
3. **Perilaku Pelanggan** : Rata-rata waktu yang dibutuhkan untuk pemesanan ulang.
4. **Segmentasi Pelanggan** : Mengidentifikasi kelompok pelanggan yang berbeda berdasarkan perilaku pembelian, demografi, atau kriteria lainnya.
5. **Analisis Profitabilitas** : Menentukan profitabilitas produk, segmen pelanggan, atau saluran penjualan yang berbeda untuk mengoptimalkan strategi bisnis.
6. **Peramalan Penjualan** : Memprediksi tren penjualan dan permintaan di masa depan untuk mengoptimalkan tingkat persediaan dan alokasi sumber daya.

### Solusi yang ditawarkan

**Data Warehouse**: Membangun data warehouse untuk menyimpan data khusus untuk tujuan analitis, terpisah dari data transaksi harian. Database akan mencakup semua yang ada di requirements gathering dan merekam setiap perubahan yang terjadi pada data-data tertentu.
**ELT-Pipeline** : Membangun alur data pipeline mulai dari extract data dari sumber , me-load datanya ke data warehouse dan kemudian transformasi datanya menjadi bentuk yang cocok dan mudah untuk dianalisis. Proses ELT ini nantinya akan dilakukan secara otomatis dan berkala.
