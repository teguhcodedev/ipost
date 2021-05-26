<?php

namespace App\Http\Controllers;

use Auth;
use Session;
use App\User;
use App\Acces;
use App\MasterUserAgent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Cache;

class UserManageController extends Controller
{
    // Create First Account
    public function firstAccount(Request $req)
    {
    	$users = new User;
        $users->username = $req->username_2;
    	$users->password = Hash::make($req->password_2);
        $users->fullname = $req->fullname_2;
    	$users->role = 'admin';
    	$users->foto = 'default.jpg';


    	$users->remember_token = Str::random(60);
    	$users->save();


        $MASTER_USER_AGENT = new MasterUserAgent;
        $MASTER_USER_AGENT->AGENT_USERNAME=$req->username_2;
        $MASTER_USER_AGENT->AGENT_NAME=$req->fullname_2;
        $MASTER_USER_AGENT->AGENT_DN=$req->phone;
        $MASTER_USER_AGENT->AGENT_PWD=Hash::make($req->password_2);
        $MASTER_USER_AGENT->AGENT_LEVEL="ADMIN";
        $MASTER_USER_AGENT->AGENT_STATUS="ACTIVE";
        $MASTER_USER_AGENT->DATE_JOIN=date('Y-m-d');
        $MASTER_USER_AGENT->LOGIN_IP= \request()->ip();
        $MASTER_USER_AGENT->PWD_EXPIRE=date('Y-m-d', strtotime("+30 days"));
        $MASTER_USER_AGENT->LOCK_STATUS=0;

        $MASTER_USER_AGENT->save();

        // $access = new Acces;
        // $access->user = $users->id;
        // $access->kelola_akun = 1;
        // $access->kelola_barang = 1;
        // $access->transaksi = 1;
        // $access->kelola_laporan = 1;
        // $access->save();



    	Session::flash('create_success', 'Akun baru berhasil dibuat');

    	return back();
    }

    // Show View Account
    public function viewAccount()
    {

        $users = DB::table('users')->get();

        // foreach ($users as $user) {
        //     if (Cache::has('user-is-online-' . $user->id))
        //         echo "User " . $user->nama . " is online.";
        //     else
        //         echo "User " . $user->nama . " is offline.";
        // }
        $id_account = Auth::id();
        // $check_access = Acces::where('user', $id_account)
        // ->first();
        // if($check_access->kelola_akun == 1){
            $users= User::paginate(6);
            $MASTER_USER_AGENT = MasterUserAgent::paginate(4);

            return view('manage_account.account', ['users'=>$users,'MUA'=>$MASTER_USER_AGENT]);

        // }else{
        //     return back();
        // }




    }

    function get_ajax_data(Request $request)
    {
     if($request->ajax())
     {
      $data = User::paginate(5);
      return view('manage_account.account', compact('data'))->render();
     }
    }

    public function getspv()
    {
      $spv = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','SPV')->pluck("AGENT_USERNAME");
      $manager = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','MANAGER')->pluck("AGENT_USERNAME");
      // dd($data->AGENT_USERNAME);
     // return $data;

    //  return Response::json(array('spv ' => $spv, 'manager' => $manager ));
      return json_encode($spv);
    }

    public function getmanager()
    {

      $manager = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','MANAGER')->pluck("AGENT_USERNAME");
      // dd($data->AGENT_USERNAME);
     // return $data;

    //  return Response::json(array('spv ' => $spv, 'manager' => $manager ));
      return json_encode($manager);
    }

    // Show View New Account
    public function viewNewAccount()
    {

        $spv = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','SPV')->get();
         $manager = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','MANAGER')->get();

        $id_account = Auth::id();
        // $check_access = Acces::where('user', $id_account)

        // ->first();
        // if($check_access->kelola_akun == 1){
        	return view('manage_account.new_account',compact('spv','manager'));
        // }else{
        //     return back();
        // }
    }

    // Filter Account Table
    public function filterTable($id)
    {
        $id_account = Auth::id();
        $check_access = Acces::where('user', $id_account)
        ->first();
        if($check_access->kelola_akun == 1){
        	$users = User::orderBy($id, 'asc')
            ->get();

        	return view('manage_account.filter_table.table_view', compact('users'));
        }else{
            return back();
        }
    }

    // Create New Account
    public function createAccount(Request $req)
    {
        dd($req);

    // dd($req->dialtype);

    //  $tr = date("Y-m-d", strtotime($req->JOIN_DATE));
    //  dd($tr);
        // dd($req->fullname);
        // dd($req->role);
             $id_account = Auth::id();
            // $check_access = Acces::where('user', $id_account)->first();

            // if($check_access->kelola_akun == 1){
                $check_username = MasterUserAgent::all()
                ->where('AGENT_USERNAME', $req->username)
                ->count();
                $check_phone = MasterUserAgent::all()
                ->where('AGENT_DN', $req->dn)
                ->count();

            if($req->foto != '' && $check_phone == 0 && $check_username == 0)
        	{

                dd($req->date_resign);
                $users = new User;
                $users->fullname = $req->fullname;
                $users->username = $req->username;
                $users->role = strtolower($req->position) ;
                $users->password = Hash::make($req->password);
                $users->remember_token = Str::random(60);
        		$foto = $req->file('foto');
                $users->foto = $foto->getClientOriginalName();
                $foto->move(public_path('chubb_foto/'), $foto->getClientOriginalName());
    	    	$users->remember_token = Str::random(60);
    	    	$users->save();


                $MUA = new MasterUserAgent;
                $MUA->AGENT_USERNAME =$req->username;
                $MUA->AGENT_NAME =$req->fullname;
                $MUA->AGENT_PWD =Hash::make($req->password);
                $MUA->SPV_ID = $req->supervisor;
                $MUA->MANAGER_ID = $req->manager;
                $MUA->AGENT_DN=$req->dn;
                $MUA->AGENT_STATUS= $req->STATUS_USER;
                $MUA->AGENT_LEVEL= $req->position;
                $MUA->DATE_JOIN= $req->JOIN_DATE;
                // if($req->date_resign=="RESIGN"){
                //     $MUA->DATE_RESIGN= $req->date_resign;
                //     $MUA->CAN_USE_SOFT_PHONE= 0;
                // }else{
                //     $MUA->EXPIRE_DATE= $req->date_resign;
                // }


                $MUA->AGENT_PHOTO = $foto->getClientOriginalName();
                $MUA->PWD_EXPIRE=date('Y-m-d', strtotime("+30 days"));
                $MUA->LOCK_STATUS=0;
                $MUA->TEAM= $req->team;
                $MUA->STS_AUDITORIAL= $req->dialtype;
                $MUA->CAN_USE_SOFTPHONE= $req->softphone;

                $MUA->save();

    	    	Session::flash('create_success', 'New Account Has been Created');

    	    	return redirect('/account');
        	}

                 if($req->foto == '' && $check_phone == 0 && $check_username == 0)
                    	{
                    		$users = new User;
                	    	$users->fullname = $req->fullname;
                	    	$users->foto = 'default.jpg';
                	    	$users->username = $req->username;
                            $users->role = strtolower($req->position) ;
                	    	$users->password = Hash::make($req->password);
                	    	$users->remember_token = Str::random(60);
                            // dd($users);
                	    	$users->save();


                            $MUA = new MasterUserAgent;
                            $MUA->AGENT_USERNAME =$req->username;
                            $MUA->AGENT_NAME =$req->fullname;
                            $MUA->AGENT_PWD =Hash::make($req->password);
                            $MUA->AGENT_PHOTO = 'default.jpg';
                            $MUA->SPV_ID = $req->supervisor;
                            $MUA->MANAGER_ID = $req->manager;
                            $MUA->AGENT_DN=$req->dn;
                            $MUA->AGENT_STATUS= $req->STATUS_USER;
                            $MUA->AGENT_LEVEL= $req->position;
                            $MUA->DATE_JOIN= $req->JOIN_DATE;
                            // if($req->date_resign != null){
                            //     $MUA->DATE_RESIGN= $req->date_resign;
                            // }else if($req->date_resign == null){
                            //     $MUA->DATE_RESIGN= null;
                            // }

                            // dd($req->date_resign);
                            $MUA->TEAM= $req->team;
                            $MUA->STS_AUDITORIAL= $req->dialtype;
                            $MUA->CAN_USE_SOFTPHONE= $req->softphone;
                            $MUA-> save();

                	    	Session::flash('create_success', 'New Account Hasbeen registered');

                	    	return redirect('/account');
                    	}
                else if($check_username != 0)
                	{
                		Session::flash('username_error', 'Username has already been registered, please try again');

                		return back();
                	}
                else if($check_phone != 0)
                	{
                		Session::flash('dn_error', 'Dialnumber has already been registered, please try again');

                		return back();
                	}
                    else{
                         return back();
                        }
    }




    // Edit Account
    public function editAccount($id)
    {
        $id_account = Auth::id();
        // $check_access = Acces::where('user', $id_account)
        // ->first();
        // if($check_access->kelola_akun == 1){
            $user = User::find($id);

            return response()->json(['user' => $user]);
        // }else{
        //     return back();
        // }
    }

    // Update Account
    public function updateAccount(Request $req)
    {
        $id_account = Auth::id();

        // $check_access = Acces::where('user', $id_account)
        // ->first();
        // if($check_access->kelola_akun == 1){
        //     $user_account = User::find($req->id);
        //     $check_email = User::all()
        //     ->where('email', $req->email)
        //     ->count();
        //     $check_username = User::all()
        //     ->where('username', $req->username)
        //     ->count();
        $user_account = User::find($req->id);
          $check_phones  = DB::table('master_user_agnets')->where('AGENT_DN', $req->dn)->get();
          $check_username  = DB::table('users')->where('username', $req->username)->get();

            if(($req->foto != '' && $check_phones == 0 && $check_username == 0) || ($req->foto != ''
            //  && $user_account->email == $req->email
             && $user_account->username == $req->username) || ($req->foto != '' && $check_phones  == 0
             && $user_account->username == $req->username) || ($req->foto != ''  && $check_username == 0))
            {
                $user = User::find($req->id);
                $user->nama = $req->nama;
                $user->role = $req->role;
                $foto = $req->file('foto');
                $user->foto = $foto->getClientOriginalName();
                $foto->move(public_path('pictures/'), $foto->getClientOriginalName());
                $user->is_banned = $req->is_banned;
                $user->username = $req->username;
                $user->save();

                Session::flash('update_success', 'Akun berhasil diubah');

                return redirect('/account');
            }
            else if(($req->foto == '' && $check_phones == 0 && $check_username == 0) || ($req->foto == '' && $user_account->email == $req->email && $user_account->username == $req->username) || ($req->foto == '' && $check_phones == 0 && $user_account->username == $req->username) || ($req->foto == '' && $user_account->email == $req->email && $check_username == 0))
            {
                if($req->nama_foto == 'default.jpg')
                {
                    $user = User::find($req->id);
                    $user->nama = $req->nama;
                    $user->role = $req->role;
                    $user->foto = $req->nama_foto;
                    $user->email = $req->email;
                    $user->is_banned = $req->is_banned;
                    $user->username = $req->username;
                    $user->save();

                    $MUA = MasterUserAgent::find($req->id);
                    $MUA->AGENT_USERNAME =$req->username;
                    $MUA->AGENT_NAME =$req->fullname;
                    $MUA->AGENT_PWD =Hash::make($req->password);
                    $MUA->AGENT_PHOTO = 'default.jpg';
                    $MUA->SPV_ID = $req->supervisor;
                    $MUA->MANAGER_ID = $req->manager;
                    $MUA->AGENT_DN=$req->dn;
                    $MUA->AGENT_STATUS= $req->STATUS_USER;
                    $MUA->AGENT_LEVEL= $req->position;
                    $MUA->DATE_JOIN= $req->JOIN_DATE;
                    if($req->date_resign=="RESIGN"){
                        $MUA->DATE_RESIGN= $req->date_resign;
                        $MUA->CAN_USE_SOFT_PHONE= 0;
                    }else{
                        $MUA->EXPIRE_DATE= $req->date_resign;
                    }

                    $MUA->TEAM= $req->team;
                    $MUA->STS_AUDITORIAL= $req->dialtype;
                    $MUA->CAN_USE_SOFTPHONE= $req->softphone;
                    $MUA-> save();

                }else{
                    $user = User::find($req->id);
                    $user->nama = $req->nama;
                    $user->role = $req->role;
                    $user->email = $req->email;
                    $user->is_banned = $req->is_banned;
                    $user->username = $req->username;
                    $user->save();

                    $MUA = MasterUserAgent::find($req->id);
                    $MUA->AGENT_USERNAME =$req->username;
                    $MUA->AGENT_NAME =$req->fullname;
                    $MUA->AGENT_PWD =Hash::make($req->password);
                    $MUA->AGENT_PHOTO = 'default.jpg';
                    $MUA->SPV_ID = $req->supervisor;
                    $MUA->MANAGER_ID = $req->manager;
                    $MUA->AGENT_DN=$req->dn;
                    $MUA->AGENT_STATUS= $req->STATUS_USER;
                    $MUA->AGENT_LEVEL= $req->position;
                    $MUA->DATE_JOIN= $req->JOIN_DATE;
                    if($req->date_resign=="RESIGN"){
                        $MUA->DATE_RESIGN= $req->date_resign;
                        $MUA->CAN_USE_SOFT_PHONE= 0;
                    }else{
                        $MUA->EXPIRE_DATE= $req->date_resign;
                    }
                    $MUA->TEAM= $req->team;
                    $MUA->STS_AUDITORIAL= $req->dialtype;
                    $MUA-> save();
                }

                Session::flash('update_success', 'Akun berhasil diubah');

                return redirect('/account');
            }
            else if($check_phones  != 0 && $check_username != 0 && $user_account->email != $req->email && $user_account->username != $req->username)
            {
                Session::flash('both_error', 'Email dan username telah digunakan, silakan coba lagi');

                return back();
            }
            else if($check_phones  != 0 && $user_account->email != $req->email)
            {
                Session::flash('email_error', 'Email telah digunakan, silakan coba lagi');

                return back();
            }
            else if($check_username != 0 && $user_account->username != $req->username)
            {
                Session::flash('username_error', 'Username telah digunakan, silakan coba lagi');

                return back();
            }
        // }else{
        //     return back();
        // }
    }

    // Delete Account
    public function deleteAccount($id)
    {
        $id_account = Auth::id();
        // $check_access = Acces::where('user', $id_account)
        // $check_access  = DB::table('users')->where('role', $id)->first();
        // ->first();
        // if($check_access->kelola_akun == 1){
            User::destroy($id);
            MasterUserAgent::destroy($id);
            // Acces::where('user', $id)->delete();

            Session::flash('delete_success', 'Akun berhasil dihapus');

            return back();
        // }else{
        //     return back();
        // }
    }
}
