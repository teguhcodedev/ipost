<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('username');
            $table->string('password');
            $table->string('fullname');
            $table->string('ip_address')->nullable();
            $table->string('last_login')->nullable();
            $table->string('role');
            $table->boolean('is_banned')->default(false);
            $table->string('foto')->nullable();
            $table->date('PWD_EXPIRE')->default(date('Y-m-d', strtotime("+30 days")))->nullable();
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}