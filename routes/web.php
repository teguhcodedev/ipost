<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', 'AuthManageController@viewLogin')->name('login');

Route::get('/login', 'AuthManageController@viewLogin')->middleware("throttle:10,2")->name('login');
Route::post('/verify_login', 'AuthManageController@verifyLogin');
Route::post('/first_account', 'UserManageController@firstAccount');

Route::group(['middleware' => ['auth', 'checkRole:admin,spv,manager,tmo,qa,customer,TMO,asisten manager,administrator']], function () {

    Route::get('/logout', 'AuthManageController@logoutProcess');
    Route::get('/', 'SidebarController@viewDashboard');
    Route::get('/chubblife-dashboard', 'ChubblifeDashboard@viewDashboard');


    // ------------------------- Setting Menu -------------------------
    // > Akun
    Route::get('/setting-menu', 'ChubblifeDashboard@settingMenu');
    Route::get('/access/change/{MenuAccess}/{MenuId}/{MenuName}/{Level}', function ($menuAccess, $menuId, $menuName, $level) {


        if ($level == 'LEVEL_SPV') {
            if ($menuAccess == 0) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_SPV' => 1]);

                return redirect()->to('/setting-menu');
            } else if ($menuAccess == 1) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_SPV' => 0]);
                return redirect()->to('/setting-menu');
                //  return 'meong';
            }
        }



        if ($level == 'LEVEL_TMR') {
            if ($menuAccess == 0) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_TMR' => 1]);
                return redirect()->to('/setting-menu');
            } else {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_TMR' => 0]);
                return redirect()->to('/setting-menu');
            }
        }


        if ($level == 'LEVEL_ATM') {
            if ($menuAccess == 0) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_ATM' => 1]);
                return redirect()->to('/setting-menu');
            } else {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_ATM' => 0]);
                return redirect()->to('/setting-menu');
            }
        }

        if ($level == 'LEVEL_ADMIN') {
            if ($menuAccess == 0) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_ADMIN' => 1]);
                return redirect()->to('/setting-menu');
            } else {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_ADMIN' => 0]);
                return redirect()->to('/setting-menu');
            }
        }

        if ($level == 'LEVEL_QA') {
            if ($menuAccess == 0) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_QA' => 1]);
                return redirect()->to('/setting-menu');
            } else {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_QA' => 0]);
                return redirect()->to('/setting-menu');
            }
        }


        if ($level == 'LEVEL_SPVQA') {
            if ($menuAccess == 0) {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_SPVQA' => 1]);
                return redirect()->to('/setting-menu');
            } else {
                DB::table('setting_menus')
                    ->where('id', $menuId)
                    ->update(['LEVEL_SPVQA' => 0]);
                return redirect()->to('/setting-menu');
            }
        }
    });


    // ------------------------- Kelola Akun -------------------------
    // > Akun
    Route::get('/account', 'Chubblife\UserManageController@viewAccount');
    Route::get('/account/new', 'Chubblife\UserManageController@viewNewAccount');
    Route::post('/account/create', 'Chubblife\UserManageController@createAccount');
    Route::get('/account/edit/{id}', 'Chubblife\UserManageController@editAccount');

    Route::get('/chubblife/edit/{id}', 'Chubblife\UserManageController@editAccount');
    Route::post('/account/update/{id}', 'Chubblife\UserManageController@updateAccount');

    Route::get('/account/delete/{id}', 'Chubblife\UserManageController@deleteAccount');
    Route::get('/account/filter/{id}', 'Chubblife\UserManageController@filterTable');

    Route::get('/account/getspv', 'Chubblife\UserManageController@getspv')->name('getspv');
    Route::get('/account/getmanager', 'Chubblife\UserManageController@getmanager')->name('getmanager');
    Route::get('chubblife/edit/getspv', 'Chubblife\UserManageController@getspv')->name('/chubblife/edit/getspv');
    Route::get('/chubblife/getmanager', 'Chubblife\UserManageController@getmanager')->name('getmanager');

    // ------------------------- Fitur Cari -------------------------
    Route::get('/search/{word}', 'SearchManageController@searchPage');
    // ------------------------- Profil -------------------------
    Route::get('/profile', 'ProfileManageController@viewProfile');
    Route::post('/profile/update/data', 'ProfileManageController@changeData');
    Route::post('/profile/update/password', 'ProfileManageController@changePassword');
    Route::post('/profile/update/picture', 'ProfileManageController@changePicture');
});

// Auth::routes();
// Route::get('/home', 'HomeController@index')->name('home');

/** --------------- routers upload data --------------------------- */

Route::get('/qa-customer-list', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.qa_customer',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/database-maintenance', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.database_maintenance',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/performance-monitoring', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.performance_monitoring',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/activity-monitoring', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.activity_monitoring',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});


Route::get('/spv-customer-search', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.spv_customer_list',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/spv-customer-list', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.spv_customer_list',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/setting-parameter', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.setting_parameter',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/self-monitoring', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.self_monitoring',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/new-data-authorization', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('performance_monitoringsetting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.new_data_authorization',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/recording-call-log', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.recording_call_log',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});


Route::get('/report', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.report',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});


Route::get('/upload-and-disttribution-data', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.upload_and_distribution_data',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/voucher', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.voucher',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});

Route::get('/print-management', function(){
    $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
    $TOTAL_MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->count();

    $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
    $TOTAL_MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->count();

    $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
    $TOTAL_MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->count();

    $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
    $TOTAL_MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->count();

    $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
    $TOTAL_MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->count();

    $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();
    $TOTAL_MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->count();
    return view('menu.print_management',compact('MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
});




/** --------------- routers upload data --------------------------- */
Route::get('/upload', 'CustomersController@index');
Route::post('/upload/import', 'CustomersController@import');
Route::get('/upload/postimport', 'CustomersController@postimport');
Route::post('/upload/uploaddata', 'CustomersController@uploaddata');
Route::get('/upload/export_excel', 'CustomersController@export_excel');

/** -----------------routers distribution data ------------------- */
Route::get('/distribution', 'CustomersController@ditribution');
Route::get('/distribution/combocampaign', 'CustomersController@ComboCampaign');
Route::get('/distribution/combostatusdata', 'CustomersController@combostatusdata');
Route::get('/distribution/checkfilter', 'CustomersController@checkfilter');
Route::get('/distribution/checkdistribution', 'CustomersController@checkdistribution');
Route::get('/distribution/distribution_list', 'CustomersController@distribution_list');
Route::get('/distribution/process_distribution', 'CustomersController@process_distribution');


/** ---------------routers recall data---------------------------- */
Route::get('/recall', 'CustomersController@recall');
Route::get('/recall/checktotaldata', 'CustomersController@checktotaldata');
Route::get('/recall/checkstatusdata', 'CustomersController@checkstatusdata');
Route::get('/recall/recall_list', 'CustomersController@recall_list');
Route::get('/recall/process_recall', 'CustomersController@process_recall');


/** --------------routers new customer list -----------------------------*/
Route::get('/newcustomerlist', 'CustomersController@newcustomerlist');

Route::get('/newcustomerlist/checkcustomerlist', 'CustomersController@checkcustomerlist');
