# Tutorial Godot 3 — Eksplorasi Mekanika Pergerakan

### Mekanika Pergerakan

| Fitur | Tombol | Deskripsi |
|-------|--------|-----------|
| **Double Jump** | `W` / `↑` | Lompat dua kali berturut-turut, termasuk saat di udara |
| **Dashing** | Double-tap `A`/`D` atau `←`/`→` | Bergerak sangat cepat untuk waktu singkat (cooldown 0.5 detik) |
| **Crouching** | `Space` (tahan) | Jongkok dengan kecepatan berkurang |

### Sistem Gameplay

| Fitur | Deskripsi |
|-------|-----------|
| **Health System** | Player memiliki 3 HP, berkurang saat terkena obstacle |
| **Score System** | Poin bertambah saat menangkap collectible object |
| **Collectibles** | Object jatuh dari atas, tangkap untuk mendapatkan poin |
| **Obstacles** | Meteor berbahaya muncul dari 3 arah (atas, kiri, kanan) |
| **Invincibility Frames** | 1 detik invicible setelah terkena obstacle |
| **Game Over** | Saat HP habis, maka Game Over |

---

## Proses Implementasi

### 1. Double Jump

Double jump memungkinkan pemain melompat satu kali lagi saat sedang di udara.

**Cara kerja:**
- Setiap kali pemain menyentuh lantai (`is_on_floor()`), `jump_count` di-reset ke 0.
- Ketika tombol `jump` ditekan dan `jump_count < max_jumps` (default: 2), karakter melompat dan counter bertambah.
- Setelah dua kali lompat, input jump diabaikan sampai pemain mendarat kembali.

```gdscript
func _handle_jump():
    if is_on_floor():
        jump_count = 0
    if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
        velocity.y = jump_speed
        jump_count += 1
```
---

### 2. Dashing

Dashing membuat karakter bergerak sangat cepat ke satu arah untuk durasi singkat. Diaktifkan dengan men-double-tap tombol arah.

**Cara kerja:**
- Setiap kali tombol arah ditekan, waktu penekanan disimpan menggunakan `Time.get_ticks_msec()`.
- Jika tombol yang sama ditekan lagi dalam `double_tap_threshold` (default: 0.3 detik), dash dimulai.
- Selama dash aktif: kecepatan horizontal diset ke `dash_speed` (600), gravitasi diabaikan.
- Node `DashTimer` (0.2 detik) mengontrol durasi, `DashCooldownTimer` (2 detik) mengontrol cooldown.

```gdscript
func _start_dash(direction: Vector2):
    is_dashing = true
    velocity.x = direction.x * dash_speed
    velocity.y = 0
    dash_timer.start()
```

---

### 3. Crouching

Crouching membuat karakter berjongkok dengan kecepatan berkurang dan collision shape atas dinonaktifkan.

**Cara kerja:**
- Ketika tombol `crouch` ditahan, `is_crouching` diset `true`, `CollisionShapeTop` di-disable.
- Kecepatan berjalan dikurangi dari `walk_speed` (200) menjadi `crouch_speed` (80).
- Ketika tombol dilepas, semua nilai dikembalikan ke normal.

---

### 4. Health & Damage System

Player memiliki 3 HP. Saat terkena obstacle, HP berkurang 1 dan player mendapat invincibility frames.

**Cara kerja:**
- `take_damage()` dipanggil oleh obstacle saat collision terjadi.
- Jika `is_invincible` aktif, damage diabaikan.
- Saat terkena: HP berkurang, hit flash shader diaktifkan via tween, sprite blink 5 kali.
- `InvincibilityTimer` (1 detik) melindungi dari damage beruntun.
- Saat HP ≤ 0, signal `died` dipancarkan → Game Over.

```gdscript
func take_damage():
    if is_invincible:
        return
    health -= 1
    health_changed.emit(health)
    is_invincible = true
    invincibility_timer.start()
    _play_hit_flash()
    if health <= 0:
        died.emit()
```
---

### 5. Collectible & Obstacle Spawning

**Collectible:** Jatuh dari atas di posisi X acak. Menggunakan `Area2D` dengan deteksi `body_entered`.

**Obstacle:** Muncul dari 3 arah (atas, kiri, kanan) dengan arah target acak dalam area permainan. Rotasi sprite sesuai arah gerak.

**Spawner:** Menggunakan dua `Timer` terpisah untuk interval spawn collectible dan obstacle.

---

### 6. Shader Effects (maaf, ini saya full dari AI, belum paham scripting shader :vVv)

Tiga custom shader GLSL untuk visual polish:

**Hit Flash (`hit_flash.gdshader`):** Mix warna putih ke sprite berdasarkan `flash_intensity` uniform yang dianimasikan via Tween.

**Glow Pulse (`glow_pulse.gdshader`):** Efek cahaya emas pulsating pada collectible menggunakan `sin(TIME * pulse_speed)`.

**Danger Pulse (`danger_pulse.gdshader`):** Efek merah pada obstacle dengan color tinting dan additive glow pulsating.

---


## Referensi

1. **Godot Documentation — InputEvent**
   https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html

2. **Godot Documentation — Tween**
   https://docs.godotengine.org/en/stable/classes/class_tween.html

3. **Godot Documentation — Signals**
   https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

4. **Game Programming Patterns — State Pattern**
    https://gameprogrammingpatterns.com/state.html
