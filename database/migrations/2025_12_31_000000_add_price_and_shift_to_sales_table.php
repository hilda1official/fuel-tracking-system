<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::table('sales', function (Blueprint $table) {
            if (!Schema::hasColumn('sales', 'price_per_litre')) {
                $table->decimal('price_per_litre', 10, 2)->nullable()->after('amount');
            }
        });
    }

    public function down(): void {
        Schema::table('sales', function (Blueprint $table) {
            if (Schema::hasColumn('sales', 'price_per_litre')) {
                $table->dropColumn('price_per_litre');
            }
        });
    }
};
