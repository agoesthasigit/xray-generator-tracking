# 📦 X-Ray Generator Tracking

Aplikasi *Tracking Generator X-Ray* berbasis *Laravel 10 + Filament, menggunakan **SQLite* agar ringan dan bisa langsung dijalankan di *GitHub Codespaces* (termasuk di iPad).

---

## 🚀 Cara Menjalankan di GitHub Codespaces

1. Buka repository ini di GitHub.  
2. Klik tombol hijau *“Code → Create codespace on main”*.  
3. Tunggu proses otomatis ±3–4 menit.  
   - Script setup.sh akan otomatis:
     - Install Laravel 10  
     - Install Filament  
     - Membuat database SQLite  
     - Membuat akun admin  
4. Setelah selesai, buka terminal di Codespaces dan jalankan:

   ```bash
   bash setup_generator.sh
   cd app
   php artisan serve --host=0.0.0.0 --port=8000
