<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Kekerasan',
                'icon' => 'fas fa-fist-raised',
                'description' => 'Laporan terkait tindakan kekerasan fisik atau verbal'
            ],
            [
                'name' => 'Bullying',
                'icon' => 'fas fa-user-slash',
                'description' => 'Laporan terkait perundungan atau intimidasi'
            ],
            [
                'name' => 'Pelanggaran Tata Tertib',
                'icon' => 'fas fa-exclamation-triangle',
                'description' => 'Laporan pelanggaran aturan dan tata tertib sekolah'
            ],
            [
                'name' => 'Penyalahgunaan Narkoba',
                'icon' => 'fas fa-pills',
                'description' => 'Laporan terkait penyalahgunaan obat-obatan terlarang'
            ],
            [
                'name' => 'Pencurian',
                'icon' => 'fas fa-mask',
                'description' => 'Laporan kehilangan atau pencurian barang'
            ],
            [
                'name' => 'Lainnya',
                'icon' => 'fas fa-ellipsis-h',
                'description' => 'Laporan pelanggaran atau kejadian lainnya'
            ]
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
