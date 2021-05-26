<?php

namespace App\Http\Controllers\Chubblife;

use App\Http\Controllers\Controller;
use App\SettingMenu;
use Illuminate\Http\Request;

class SettingMenuController extends Controller
{

       // Change Access
       public function changeAccess($columnName, $id_menu)
       {
           $menuValue = SettingMenu::where('id', $id_menu)->first();
           $menuValue->year = $request->year;
           $book->update();
        //    if($pengguna->$access == 1){
        //        Acces::where('user', $user)
        //        ->update([$access => 0]);
        //    }else{
        //        Acces::where('user', $user)
        //        ->update([$access => 1]);
        //    }
        //    $access = Acces::join('users', 'users.id', '=', 'access.user')
        //    ->select('access.*', 'users.*')
        //    ->get();
           return view('manage_account.access_table', compact('access'));
       }

        // Sidebar Refresh
    public function sidebarRefresh()
    {
    	return view('templates.sidebar');
    }
}
