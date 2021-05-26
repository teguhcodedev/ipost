<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSettingMenusTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('setting_menus', function (Blueprint $table) {
            $table->id();
            $table->string("MENU_NAME");
            $table->string("MENU_LINK");
            $table->boolean("LEVEL_TMR");
            $table->boolean("LEVEL_SPV");
            $table->boolean("LEVEL_ATM");
            $table->boolean("LEVEL_ADMIN");
            $table->boolean("LEVEL_QA");
            $table->boolean("LEVEL_SPVQA");
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
        Schema::dropIfExists('setting_menus');
    }
}
