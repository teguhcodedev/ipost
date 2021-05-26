<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMasterUserAgentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('MASTER_USER_AGENTS', function (Blueprint $table) {
            $table->id();
            $table->string('AGENT_USERNAME',50);
            $table->string('AGENT_NAME',50)->nullable();
            $table->string('AGENT_PWD');
            $table->string('AGENT_LEVEL',20)->nullable();
            $table->string('AGENT_DN',15)->nullable();
            $table->string('AGENT_STATUS',20)->nullable();
            $table->string('AGENT_TIME')->nullable();
            $table->string('GROUP_ID',20)->nullable();
            $table->string('LEADER_ID',30)->nullable();
            $table->string('SPV_ID',30)->nullable();
            $table->string('MANAGER_ID',20)->nullable();
            $table->date('LAST_UPDATE',20)->nullable();
            $table->string('STS_AUTODIAL',10)->nullable();
            $table->string('STS_AUDITORIAL',20)->nullable();
            $table->date('PWD_EXPIRE')->default(date('Y-m-d', strtotime("+30 days")))->nullable();
            $table->string('RUNNING_STATUS')->nullable();;
            $table->date('DATE_JOIN')->nullable();;
            $table->date('DATE_RESIGN')->nullable();
            $table->string('TEAM',20)->default("TEAM 1")->nullable();
            $table->string('CREATE_USER',20)->default("ADMIN")->nullable();
            $table->string('BALANCE_VOUCHER',20)->default("NULL")->nullable();
            $table->date('EXPIRE_DATE')->nullable();
            $table->string('AGENT_GROUP',30)->default("NULL")->nullable();
            $table->boolean('LOGIN_STATUS')->default(0)->nullable();
            $table->boolean('LOCK_STATUS')->default(0)->nullable();
            $table->string('APPROVE_VOUCHER',30)->default("NULL")->nullable();
            $table->string('TEAM_QA',30)->default("NULL")->nullable();
            $table->boolean('CAN_USE_SOFTPHONE')->default(0)->nullable();
            $table->datetime('LAST_ACCESS')->nullable();
            $table->datetime('LAST_UPDATED_BY')->nullable();
            $table->boolean('IS_DELETED')->default(0)->nullable();
            $table->string('AGENT_PHOTO')->nullable();
            $table->string('LEVEL_TARGET',20)->nullable();
            $table->string('ID_MITRA',20)->nullable();
            $table->string('ID_MITRA_BNILIFE')->nullable();
            $table->date('CREATE_DATE')->nullable();
            $table->date('EDIT_DATE',30)->nullable();
            $table->date('SPONSOR')->nullable();
            $table->string('PRODUCT',30)->nullable();
            $table->string('LOGIN_IP')->nullable();
            $table->string('BS_VERSION',30)->default("Animates 04")->nullable();
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
        Schema::dropIfExists('master_user_agents');
    }
}
