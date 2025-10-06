#!/bin/bash
set -e

echo "⚙ Membuat struktur database untuk Tracking Generator X-Ray..."

cd app

# 1️⃣ Buat model & migration untuk XRay
php artisan make:model XRay -m
cat > database/migrations/2025_01_01_000001_create_x_rays_table.php <<'EOL'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('x_rays', function (Blueprint $table) {
            $table->id();
            $table->string('nama_xray')->unique();
            $table->string('lokasi')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('x_rays');
    }
};
EOL

# 2️⃣ Buat model & migration untuk Generator
php artisan make:model Generator -m
cat > database/migrations/2025_01_01_000002_create_generators_table.php <<'EOL'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('generators', function (Blueprint $table) {
            $table->string('serial_number')->primary();
            $table->foreignId('x_ray_id')->nullable()->constrained('x_rays')->onDelete('set null');
            $table->date('tanggal_datang')->nullable();
            $table->date('tanggal_pasang')->nullable();
            $table->string('posisi_pasang')->nullable();
            $table->string('pic_pemasang')->nullable();
            $table->date('tanggal_pindah')->nullable();
            $table->string('garansi')->nullable();
            $table->string('posisi_terakhir')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('generators');
    }
};
EOL

# 3️⃣ Jalankan migrasi
php artisan migrate

# 4️⃣ Tambahkan data sample
php artisan tinker --execute="
use App\Models\XRay;
use App\Models\Generator;

\$xr1 = XRay::create(['nama_xray' => 'X-Ray 1', 'lokasi' => 'Ruang Radiologi A']);
\$xr2 = XRay::create(['nama_xray' => 'X-Ray 2', 'lokasi' => 'Ruang Radiologi B']);
\$xr3 = XRay::create(['nama_xray' => 'X-Ray 3', 'lokasi' => 'Ruang Radiologi C']);

Generator::create(['serial_number' => 'GEN1001', 'x_ray_id' => \$xr1->id, 'tanggal_datang' => '2024-07-01', 'tanggal_pasang' => '2024-07-05', 'posisi_pasang' => 'Belakang', 'pic_pemasang' => 'Andi', 'garansi' => '2 Tahun', 'posisi_terakhir' => 'X-Ray 1']);
Generator::create(['serial_number' => 'GEN1002', 'x_ray_id' => \$xr2->id, 'tanggal_datang' => '2024-07-03', 'tanggal_pasang' => '2024-07-06', 'posisi_pasang' => 'Kanan', 'pic_pemasang' => 'Budi', 'garansi' => '2 Tahun', 'posisi_terakhir' => 'X-Ray 2']);
Generator::create(['serial_number' => 'GEN1003', 'x_ray_id' => \$xr3->id, 'tanggal_datang' => '2024-07-10', 'tanggal_pasang' => '2024-07-12', 'posisi_pasang' => 'Depan', 'pic_pemasang' => 'Citra', 'garansi' => '3 Tahun', 'posisi_terakhir' => 'X-Ray 3']);
"

echo "✅ Struktur tabel X-Ray dan Generator berhasil dibuat!"
echo "Jalankan server dengan: php artisan serve --host=0.0.0.0 --port=8000"
