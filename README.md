# Aplikasi Manajemen Barang

Aplikasi ini adalah aplikasi manajemen barang sederhana yang dibuat menggunakan Lazarus (Free Pascal). Aplikasi ini memungkinkan pengguna untuk menambah, mengedit, menghapus, dan menampilkan data barang, termasuk gambar barang yang disimpan dalam field BLOB pada database SQLite.

## Fitur

- **Tambah Barang:** Tambahkan data barang baru ke dalam database, termasuk ID barang, nama barang, stok, tanggal masuk, dan gambar.
- **Edit Barang:** Edit data barang yang sudah ada di database.
- **Hapus Barang:** Hapus data barang dari database.
- **Cari Barang:** Cari barang berdasarkan ID atau nama barang.
- **Laporan:** Cetak laporan data barang menggunakan LazReport.

## Komponen Utama

- `TButton`: Untuk mengontrol berbagai aksi seperti tambah, simpan, hapus, dan edit barang.
- `TDBGrid`: Menampilkan data barang dalam bentuk tabel.
- `TEdit`: Input teks untuk ID barang, nama barang, dan stok barang.
- `TDateTimePicker`: Pilih tanggal masuk barang.
- `TImage`: Menampilkan gambar barang.
- `TfrReport`: Komponen LazReport untuk mencetak laporan.
- `TSQLQuery`: Mengelola query SQL untuk manipulasi data di database.
- `TfrDBDataSet`: Data set yang menghubungkan database dengan laporan.

## Struktur Kode

- **SearchEditChange**: Menangani perubahan teks pada kolom pencarian untuk memfilter data barang.
- **LoadImageFromBlobField**: Memuat gambar dari field BLOB dalam database ke komponen TImage.
- **SetImageToBlobField**: Menyimpan gambar dari TImage ke field BLOB dalam database.
- **enablededitor**: Mengaktifkan atau menonaktifkan komponen input berdasarkan aksi yang sedang dilakukan (tambah/edit).
- **Button1Click**: Menangani aksi saat tombol tambah/simpan ditekan.
- **Button2Click**: Menangani aksi saat tombol hapus/batal ditekan.
- **Button3Click**: Membuka dialog untuk memilih gambar barang.
- **Button4Click**: Menangani aksi saat tombol edit/simpan ditekan.
- **Button5Click**: Menampilkan laporan data barang menggunakan LazReport.
- **DBGrid1SelectEditor**: Menangani seleksi baris pada TDBGrid untuk menampilkan detail barang yang dipilih.
- **FormActivate**: Mengaktifkan koneksi ke database saat form diaktifkan.
- **FormCreate**: Dipanggil saat form dibuat.
- **FormDestroy**: Menangani pembebasan sumber daya saat form dihancurkan.

## Persyaratan

- **Lazarus (Free Pascal)**: IDE untuk pengembangan aplikasi ini.
- **SQLite**: Database untuk menyimpan data barang.

## Penggunaan

1. **Menambahkan Barang:**
   - Klik tombol "Tambah" untuk mengaktifkan form input.
   - Isi data barang yang diperlukan.
   - Klik "Simpan" untuk menyimpan data barang ke database.

2. **Mengedit Barang:**
   - Pilih barang yang ingin diedit dari tabel.
   - Klik tombol "Edit" untuk mengaktifkan form input.
   - Modifikasi data barang sesuai keinginan.
   - Klik "Simpan" untuk menyimpan perubahan.

3. **Menghapus Barang:**
   - Pilih barang yang ingin dihapus dari tabel.
   - Klik tombol "Hapus" untuk menghapus data barang dari database.

4. **Mencetak Laporan:**
   - Klik tombol "Cetak" untuk menampilkan laporan data barang.

## Lisensi

Proyek ini dilisensikan di bawah [MIT License](https://opensource.org/licenses/MIT).
