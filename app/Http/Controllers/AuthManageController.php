<?php

namespace App\Http\Controllers;

use App\MasterUserAgent;
use Auth;
use Session;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AuthManageController extends Controller
{
    // Show View Login
    public function viewLogin()
    {
    	$users = User::all()
    	->count();

    	return view('login', compact('users'));
    }

    // Verify Login
    public function verifyLogin(Request $request)
    {


    	if(Auth::attempt($request->only('username', 'password'))){

            User::where('username',$request->username)->update(
                ['ip_address'=>\request()->ip()]
            );



            MasterUserAgent::where('AGENT_USERNAME', $request->username)
                    ->update(
                        ['LOGIN_STATUS' => '1'],
                        ['LOGIN_IP'=>\request()->ip()]

            );

            $user = Auth::user();
            return redirect('/chubblife-dashboard');
            // if($user->role=='admin'){
            //      return redirect('/chubblife-dashboard');
            //     // $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
            //     // return view('dashboard.admin',compact('MENU_ADMIN'));
            // }else if($user->role=='spv'){
            //     $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
            //     return view('dashboard.spv',compact('MENU_SPV'));
            // }else  if($user->role=='manager'){
            //     return view('dashboard.manager');
            // }else  if($user->role=='telemarketer'){
            //     return view('dashboard.telemarketer');
            // }
            // dd($user->role);

    		// return redirect('/chubblife-dashboard');
    	}
    	 Session::flash('login_failed', 'Username atau password salah');

    	return redirect('/login');
    }

    // Logout Process
    public function logoutProcess()
    {
        $user = Auth::user();
        User::where('id',$user->id)->update(
            ['last_login'=>date('Y-m-d H:i:s')]
        );

        MasterUserAgent::where('id', $user->id)
        ->update(
            ['LOGIN_STATUS' => '0'],

);

    	Auth::logout();

    	return redirect('/login');
    }
}
