use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        if (DB::getDriverName() !== 'mysql') {
            return;
        }

        Schema::table('pumps', function (Blueprint $table) {
            if (Schema::hasColumn('pumps', 'fuel_id')) {
                $table->dropForeign(['fuel_id']);
                $table->dropColumn('fuel_id');
            }
        });
    }

    public function down(): void
    {
        if (DB::getDriverName() !== 'mysql') {
            return;
        }

        Schema::table('pumps', function (Blueprint $table) {
            if (!Schema::hasColumn('pumps', 'fuel_id')) {
                $table->foreignId('fuel_id')
                      ->nullable()
                      ->constrained('fuels')
                      ->cascadeOnDelete();
            }
        });
    }
};
