<?php

namespace App\Http\Controllers\Chubblife;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Auth;
use Session;
use App\User;
use App\Acces;
use App\MasterUserAgent;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Hash;

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
         $MASTER_USER_AGENT->AGENT_PHOTO='default.jpg';

         $MASTER_USER_AGENT->save();

         Session::flash('create_success', 'Akun baru berhasil dibuat');

         return back();
     }

     // Show View Account
     public function viewAccount()
     {

        $MENU_ADMIN = DB::table('setting_menus')->WHERE('LEVEL_ADMIN',1)->get();
        $MENU_TMR = DB::table('setting_menus')->WHERE('LEVEL_TMR',1)->get();
        $MENU_SPV = DB::table('setting_menus')->WHERE('LEVEL_SPV',1)->get();
        $MENU_ATM = DB::table('setting_menus')->WHERE('LEVEL_ATM',1)->get();
        $MENU_QA = DB::table('setting_menus')->WHERE('LEVEL_QA',1)->get();
        $MENU_SPVQA = DB::table('setting_menus')->WHERE('LEVEL_SPVQA',1)->get();

         $users = DB::table('users')->get();
         $id_account = Auth::id();
         $check_access = MasterUserAgent::select('AGENT_LEVEL')->where('id', $id_account)->get();
         if($check_access[0]->AGENT_LEVEL=="ADMIN"){
             $users= User::paginate(6);
             $MASTER_USER_AGENT = MasterUserAgent::paginate(4);

             return view('manage_account.account',
              [
              'MENU_ADMIN'=>$MENU_ADMIN,
              'MENU_TMR'=>$MENU_TMR,
              'MENU_SPV'=>$MENU_SPV,
              'MENU_ATM'=>$MENU_ATM,
              'MENU_QA'=>$MENU_QA,
              'MENU_SPVQA'=>$MENU_SPVQA,
              'MUA'=>$MASTER_USER_AGENT
              ]);

         }else{
             return back();
         }
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
       return json_encode($spv);
     }

     public function getmanager()
     {

       $manager = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','MANAGER')->pluck("AGENT_USERNAME");
       return json_encode($manager);
     }

     // Show View New Account
     public function viewNewAccount()
     {

          $spv = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','SPV')->get();
          $manager = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','MANAGER')->get();

         $id_account = Auth::id();
         $check_access = MasterUserAgent::select('AGENT_LEVEL')->where('id', $id_account)->get();

         $users = MasterUserAgent::paginate(3);

         if($check_access[0]->AGENT_LEVEL=="ADMIN"){
             return view('manage_account.new_account',compact('spv','manager','users'));
         }else{
            Session::flash('Failed', 'You are not administrator');
             return back();
         }
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

              $id_account = Auth::id();
              $check_access = MasterUserAgent::select('AGENT_LEVEL')->where('id', $id_account)->get();


            if($check_access[0]->AGENT_LEVEL=="ADMIN"){
                 $check_username = MasterUserAgent::all()
                 ->where('AGENT_USERNAME', $req->username)
                 ->count();
                 $check_phone = MasterUserAgent::all()
                 ->where('AGENT_DN', $req->dn)
                 ->count();

             if($req->foto != '' && $check_phone == 0 && $check_username == 0)
             {
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
                 if($req->date_resign=="RESIGN"){
                     $MUA->DATE_RESIGN= $req->date_resign;
                     $MUA->CAN_USE_SOFT_PHONE= 0;
                 }else{
                     $MUA->EXPIRE_DATE= $req->date_resign;
                 }


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
                             $MUA->DATE_RESIGN= $req->date_resign;
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
     }else{
        return back();
     }
    }


    public function editAccount($id)
    {
        $id_account = Auth::id();
        $check_access = MasterUserAgent::select('AGENT_LEVEL')->where('id',  $id_account)->get();


        if($check_access[0]->AGENT_LEVEL=="ADMIN"){
        $user = User::find($id);
        $MUA = MasterUserAgent::find($id);
        $spv = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','SPV')->get();
        $manager = DB::table("MASTER_USER_AGENTS")->where('AGENT_LEVEL','MANAGER')->get();

        $user = DB::table('users')->where('id', $id)->first();
        return view('chubblife.edit.edituser', compact('user','spv','manager','MUA'));
        }
        else{
            return back();
        }
    }

     // Update Account
     public function updateAccount(Request $req)
     {
         $id_account = Auth::id();

        //  dd($req);

         //dd($req->foto);

           $user_account = User::find($req->id);
           $MUA_ACCOUNT = MasterUserAgent::find($req->id);
           $check_phones  = DB::table('master_user_agents')->where('AGENT_DN', $req->dn)->get();
           $check_username  = DB::table('users')->where('username', $req->username)->get();

           //dd($check_username);

             if(($req->foto != '') || ($req->foto != ''
              && $user_account->username == $req->username) || ($req->foto != '' && $check_phones  == 0
              && $user_account->username == $req->username) || ($req->foto != ''  && $check_username == 0))
             {

                $user = User::find($req->id);
                $user->fullname = $req->fullname;


                $user->username = $req->username;
                $user->role = strtolower($req->position) ;

                $foto = $req->file('foto');
                $user->foto = $foto->getClientOriginalName();
                $foto->move(public_path('chubb_foto/'), $foto->getClientOriginalName());
                $user->remember_token = Str::random(60);
                $user->save();


                $MUA = MasterUserAgent::find($req->id);
                $MUA->AGENT_USERNAME =$req->username;
                $MUA->AGENT_NAME =$req->fullname;
                $MUA->AGENT_PWD =Hash::make($req->password);
                $MUA->SPV_ID = $req->supervisor;
                $MUA->MANAGER_ID = $req->manager;
                $MUA->AGENT_DN=$req->dn;
                $MUA->AGENT_STATUS= $req->STATUS_USER;
                $MUA->AGENT_LEVEL= $req->position;
                $MUA->DATE_JOIN= $req->JOIN_DATE;
                if($req->date_resign==""){
                    $MUA->DATE_RESIGN= $req->date_resign;
                }
                else if($req->date_resign=="RESIGN"){
                    $MUA->DATE_RESIGN= $req->date_resign;
                    $MUA->CAN_USE_SOFT_PHONE= 0;
                }else{
                    $MUA->EXPIRE_DATE= $req->date_resign;
                }


                $MUA->AGENT_PHOTO = $foto->getClientOriginalName();
                $MUA->PWD_EXPIRE=date('Y-m-d', strtotime("+30 days"));
                $MUA->LOCK_STATUS=0;
                $MUA->TEAM= $req->team;
                $MUA->STS_AUDITORIAL= $req->dialtype;
                $MUA->CAN_USE_SOFTPHONE= $req->softphone;

                $MUA->save();


                 Session::flash('update_success', 'Akun berhasil diubah');

                 return redirect('/account');
             }

             else if(
                 ($req->foto == '') ||
                 ($req->foto == '' && $MUA_ACCOUNT->AGENT_DN == $req->dn && $user_account->username == $req->username) ||
                  ($req->foto == '' && $check_phones == 0 && $user_account->username == $req->username) ||
                  ($req->foto == '' && $MUA_ACCOUNT->AGENT_DN == $req->dn && $check_username == 0))
             {
                 if($req->nama_foto == 'default.jpg')
                 {
                     $user = User::find($req->id);
                     $user->username = $req->username;
                     $user->role = strtolower($req->position) ;
                     $user->foto = $req->foto;
                     $user->fullname = $req->fullname;
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
                     if($req->date_resign==""){
                        $MUA->DATE_RESIGN= $req->date_resign;
                    }
                     else if($req->date_resign=="RESIGN"){
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
                     $user->fullname = $req->fullname;
                     $user->role = strtolower($req->position) ;
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
                     if($req->date_resign==""){
                        $MUA->DATE_RESIGN= $req->date_resign;
                    }
                    else if($req->date_resign=="RESIGN"){
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
             else if($check_phones  != 0 && $check_username != 0 && $user_account->username != $req->username && $user_account->username != $req->username)
             {
                 Session::flash('both_error', ' username amd phone number already been used, please try agent');

                 return back();
             }
             else if($check_phones  != 0 && $MUA_ACCOUNT->AGENT_DN != $req->dn)
             {
                 Session::flash('email_error', 'Phone number already been used, please try agent');

                 return back();
             }
             else if($check_username != 0 && $user_account->username != $req->username)
             {
                 Session::flash('username_error', 'Username already been used, please try agent');

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
         $check_access = MasterUserAgent::select('AGENT_LEVEL')->where('id', $id_account)->get();

         if($check_access[0]->AGENT_LEVEL=="ADMIN"){
             User::destroy($id);
             MasterUserAgent::destroy($id);

             Session::flash('delete_success', 'Akun berhasil dihapus');

             return back();
         }else{
            Session::flash('delete_success', 'Akun berhasil dihapus');
             return back();
         }
     }
}
