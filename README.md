# Meteor Survival — Procedural Survival Game

note: saya menggunakan AI dalam menyusun README ini (maaf saya sedang lelah dibantai PPL :D)

Sebuah modifikasi dari tutorial Godot 3 yang mengubah permainan platformer dasar menjadi game survival bertahan hidup dari hujan meteor yang terus berkembang secara prosedural.

## Kontrol Permainan

| Aksi | Tombol | Deskripsi |
|------|--------|-----------|
| **Lompat** | `W` | Melompat (mendukung Double Jump) |
| **Gerak** | `A` / `D` | Bergerak ke kiri dan kanan |
| **Bidik (Aim)** | `←` / `→` | Memutar arah bidikan (radius 180° di atas pemain) |
| **Tembak** | `Space` (tahan) | Menembak proyektil secara otomatis (Rapid Fire) |

---

## Fitur Utama Gameplay

### 1. Prosedural Meteor Survival
Pemain harus bertahan dari hujan meteor yang jatuh dari langit. Permainan tidak berakhir sampai HP pemain habis.
- **Difficulty Scaling**: Semakin lama bertahan, interval kemunculan meteor semakin cepat.
- **Meteor Hardness**: Seiring berjalannya waktu, meteor yang muncul akan memiliki HP lebih tinggi (lebih keras) dan warna yang lebih gelap.
- **Score System**: Poin didapatkan setiap kali meteor dihancurkan, dihitung berdasarkan tingkat kekerasan meteor tersebut.

### 2. Mekanika Tempur & Bidikan
- **Rotational Aiming**: Garis merah menunjukkan arah tembakan. Pemain dapat memutar sudut bidikan dari kiri ke kanan (180 derajat).
- **Automatic Rapid Fire**: Menahan tombol tembak akan meluncurkan proyektil secara terus-menerus dengan jeda cooldown yang sangat singkat (0.08 detik).

### 3. Sistem Audio & Feedback
- **SFX Feedback**: Suara laser saat menembak dan suara ledakan saat meteor hancur.
- **Dynamic BGM**: Musik latar akan berhenti saat pemain kalah, digantikan oleh efek suara kekalahan (Losing Horn) di layar Game Over.
- **Visual Feedback**: Meteor berubah warna menjadi kemerahan saat terkena damage sebelum akhirnya meledak.

---

## Detail Implementasi Teknis

### 1. Rotational Aiming (Sudut 180°)
Bidikan menggunakan sistem sudut (`aim_angle`) yang dibatasi antara -180° hingga 0°. Vektor arah dihitung menggunakan fungsi trigonometri `cos` dan `sin` untuk memastikan akurasi proyektil.

### 2. Difficulty Scaling pada Spawner
Spawner menghitung `survival_time` dan mengubah interval spawn secara dinamis. Nilai kesulitan (`difficulty`) diteruskan ke setiap meteor yang di-instantiate untuk menentukan HP, kecepatan jatuh, dan kegelapan warnanya.

### 3. Mekanika Automatic Shooting
Menggunakan `Timer` internal pada script Player. Ketika tombol tembak ditahan, script mengecek apakah `can_shoot` bernilai true, memulai timer cooldown, dan memunculkan proyektil.

---

## Credits & Referensi
- **Assets**: Kenney (Platformer Characters & SFX).
- **Engine**: Godot Engine 4.
- **Audio**: Custom placeholder SFX (Laser, Explosion, Losing Horn).
