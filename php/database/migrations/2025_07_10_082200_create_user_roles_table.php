<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUserRolesTable extends Migration
{
    private string $tableName = 'user_roles';
    private array $roles = [
        'Administrator',
        'Author',
        'Editor',
        'Subscriber',
    ];

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create($this->tableName, function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->timestamps();
        });

        $roles = array_map(function ($role) {
            return [
                'name' => $role,
                'created_at' => now(),
            ];
        }, $this->roles);

        // Insert default Admin role
        DB::table($this->tableName)->insert($roles);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists($this->tableName);
    }
}
