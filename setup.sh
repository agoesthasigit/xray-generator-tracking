#!/bin/bash
set -e

echo "🚀 Menyiapkan Laravel + Filament untuk Tracking Generator X-Ray..."

# 1️⃣ Buat project Laravel baru
composer create-project laravel/laravel app "10.*"
cd app

# 2️⃣ Install Filament
composer require filament/filament:"^3.2" --no-interaction

# 3️⃣ Buat database SQLite
touch database/database.sqlite
php artisan migrate

# 4️⃣ Tambahkan user admin default
php artisan make:model User -m
cat > database/migrations/9999_01_01_000000_create_admin_user.php <<'EOL'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void {
        DB::table('users')->insert([
            'name' => 'Admin',
            'email' => 'admin@xray.local',
            'password' => Hash::make('mvxr5000'),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function down(): void {
        DB::table('users')->where('email', 'admin@xray.local')->delete();
    }
};
EOL

php artisan migrate

# 5️⃣ Install Laravel UI & Filament panel
php artisan make:filament-user admin@xray.local --name="Admin" --password="mvxr5000"

# 6️⃣ Pesan akhir
echo "✅ Instalasi selesai!"
echo "Login ke Filament di: http://localhost:8000/admin"
echo "Email: admin@xray.local | Password: mvxr5000"
