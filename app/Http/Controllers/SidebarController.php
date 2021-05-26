<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SidebarController extends Controller
{
    public function viewDashboard()
    {


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

        return view('templates.coba',compact(
            'MENU_ADMIN','MENU_TMR','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA',
            'TOTAL_MENU_ADMIN', 'TOTAL_MENU_TMR','TOTAL_MENU_SPV',
            'TOTAL_MENU_ATM','TOTAL_MENU_QA','TOTAL_MENU_SPVQA'
      ));
    }
}
