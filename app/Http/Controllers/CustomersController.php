<?php

namespace App\Http\Controllers;

use App\CustomerPreview;
use App\Exports\CustomersExport;
use App\Helpers\SiteHelpers;
use Illuminate\Http\Request;
use App\Imports\CustomersImport;
use App\User;
use Illuminate\Support\Facades\Auth;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;
use phpDocumentor\Reflection\DocBlock\Tags\Return_;

class CustomersController extends Controller
{

    /** -------------- batas awal contoller upload data ------------------------ */
    public function index()
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
        DB::table('temp_preview_customers')->delete();
        $temp_preview = CustomerPreview::all();
        return view('upload-data.upload', compact('temp_preview','MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
    }
    public function import(Request $request)
    {
        DB::table('temp_preview_customers')->delete();
        $this->validate($request, [
            'file' => 'required|mimes:xls,xlsx|max:1000000',
        ]);
        $file = $request->file('file');
        $nama_file = rand() . $file->getClientOriginalName();
        $path = $file->storeAs('public/excel/', $nama_file);
        $import = Excel::import(new CustomersImport(), storage_path('app/public/excel/' . $nama_file));
        Storage::delete($path);
        $data = CustomerPreview::all();
        if ($import && !empty($data) && $data->count()) {
            return redirect('/upload/postimport');
        } else {
            Session::flash('create_failed', 'empty data');
            return back();
        }
    }
    public function postimport()
    {
        $temp_preview = CustomerPreview::all();
        return view('upload-data.upload', ['temp_preview' => $temp_preview]);
    }


    public function uploaddata(Request $request)
    {
        $in_sponsor = $request->sponsor;
        $in_jenis_customer =  $request->product_group;
        $in_customer_type = $request->customer_type;
        $in_customer_type_detail =  $request->customer_type_detail;
        $in_data_card_type =  $request->data_card_type;
        $in_campaign_name = $request->campaign_name;
        if ($request->has('unlimited_exp_date')) {
            $in_unlimitexpdate = 'TRUE';
        } else {
            $in_unlimitexpdate = 'FALSE';
        }
        if ($request->has('bypass_duplicate_data')) {
            $in_bypass_dup_data = 'TRUE';
        } else {
            $in_bypass_dup_data = 'FALSE';
        }

        if (DB::table('master_customer')->where('CAMPAIGN_NAME', $in_campaign_name)->exists()) {
            $in_cek_dup_Campaign  = 'TRUE';
        } else {
            $in_cek_dup_Campaign  = 'FAlSE';
        }
        $id = Auth::id();
        $user = User::find($id);

        $data = CustomerPreview::all();
        if (!empty($data) && $data->count()) {
            foreach ($data as $value) {
                $mphone = SiteHelpers::notelp($value->mphone);
                $bphone = SiteHelpers::notelp($value->bphone);
                $hphone = SiteHelpers::notelp($value->hphone);
                DB::select(
                    'CALL  spSaveData_Upload(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                    array(
                        $value->cust_id,
                        $value->name,
                        $mphone,
                        $bphone,
                        $hphone,
                        $value->sex,
                        $value->agenow,
                        $value->zipcode,
                        $value->jenis_kartu,
                        $in_sponsor,
                        $in_jenis_customer,
                        $in_customer_type,
                        $in_customer_type_detail,
                        $in_data_card_type,
                        $in_campaign_name,
                        $in_unlimitexpdate,
                        $in_cek_dup_Campaign,
                        $user->username,
                        $value->id,
                        $in_bypass_dup_data
                    )
                );
            }
            $succesdata = DB::table('temp_preview_customers')->where('status_upload', 'Success Upload Data!!')->count();
            $alldatapreview = $data = DB::table('temp_preview_customers')->count();
            if ($succesdata == $alldatapreview) {
                Session::flash('create_success', 'all data succes upload');
            } elseif ($succesdata <= 0) {
                Session::flash('update_failed', 'semua data gagal terupload');
            } else {
                Session::flash('notif_warning', 'sebagian data gagal terupload');
            }
            return redirect('/upload/postimport');
        } else {
            Session::flash('create_failed', 'empty data');
            return back();
        }
        //return dd($user->username);
    }

    public function export_excel()
    {
        //return Excel::download(new CustomersExport, 'Customers.xlsx');
        return new CustomersExport();
    }
    /** ============== batas akhir cotroller upload data*===========================*/

    /** -------------- batas awal contoller distribution data ------------------------ */
    public function ditribution()
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

        $id = Auth::id();
        $user = User::find($id);
        $criteria = 'product_group_distribution';
        $ProductGroup = DB::select(
            'CALL  spComboboxDistribution(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                "",
                ""
            )
        );

        return view('distribution-data.distribution', compact('user','ProductGroup','MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
    }

    public function ComboCampaign(Request $request)
    {
        $criteria = 'campaign_name_distribution';
        $id = Auth::id();
        $user = User::find($id);
        $product_group = $request->product;
        $data = DB::select(
            'CALL  spComboboxDistribution(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                $product_group,
                ""
            )
        );

        return response()->json($data);
        //return dd($product);
    }



    public function combostatusdata(Request $request)
    {
        $criteria = 'CAMPAIGN_DISTRIBUTION_STATUSDATA';
        $id = Auth::id();
        $user = User::find($id);
        $campaign = $request->campaign;
        $data = DB::select(
            'CALL  spComboboxDistribution(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                "",
                $campaign
            )
        );
        return response()->json($data);
        //return dd($data);
    }


    public function checkfilter(Request $request)
    {

        if ($request->filter == 'Gender') {
            $criteria = 'Filter Gender';
        } elseif ($request->filter == 'Type Of Card') {
            $criteria = 'Filter Type Of Card';
        } else {
            $criteria = '';
        }


        $id = Auth::id();
        $user = User::find($id);
        $campaign = $request->campaign;
        $data = DB::select(
            'CALL  spComboboxDistribution(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                "",
                $campaign
            )
        );
        return response()->json($data);
    }



    public function checkdistribution(Request $request)
    {
        $criteria = 'CAMPAIGN_DISTRIBUTION_STATUSDATA_SUMMARY';
        $campaign = $request->campaign;
        $status_data = $request->status_data;
        $str = (explode("|", $status_data));
        $status_data1 = $str[0];
        if (count($str) <= 1) {
            $status_data2 = "";
        } else {
            $status_data2 = $str[1];
        }
        $filter_group = $request->filter_group;
        $lower_age = $request->lower_age;
        $upper_age = $request->upper_age;
        $data_card_type = $request->data_card_type;
        $zipcode = $request->zipcode;
        $gender = $request->gender;

        $id = Auth::id();
        $user = User::find($id);
        $data = DB::select(
            'CALL  spGetDistribution_Detail(?,?,?,?,?,?,?,?,?,?,?)',
            array(
                $criteria,
                $campaign,
                $user->username,
                $status_data1,
                $status_data2,
                $filter_group,
                $lower_age,
                $upper_age,
                $data_card_type,
                $zipcode,
                $gender
            )
        );
        return response()->json($data);

        //return dd($zipcode);
    }



    public function distribution_list(Request $request)
    {
        $criteria = 'DISTRIBUTION';
        $id = Auth::id();
        $user = User::find($id);
        $data = DB::select(
            'CALL  spGetDistribution_List(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                $request->selectlevel,
                $request->campaign
            )
        );
        return response()->json($data);

        //return dd($data);
    }


    public function process_distribution(Request $request)
    {

        $campaign = $request->campaign;
        $status_data = $request->status_data;
        $str = (explode("|", $status_data));
        if (count($str) <= 1) {

            if ($str[0] == 'Fresh Data') {
                $status_data1 = "";
            } else {
                $status_data1 = $str[0];
            }
            $status_data2 = "";
        } else {
            $status_data1 = $str[0];
            $status_data2 = $str[1];
        }
        $filter_group = $request->filter_group;
        if ($request->lower_age == "NaN") {

            $lower_age = "";
        } else {
            $lower_age = $request->lower_age;
        }
        if ($request->upper_age == "NaN") {
            $upper_age = "";
        } else {
            $upper_age = $request->upper_age;
        }
        $data_card_type = $request->data_card_type;
        $zipcode = $request->zipcode;
        $gender = $request->gender;
        $selected_level = $request->selectlevel;
        $total_dist = $request->total_dist;
        $user_dist = $request->user_dist;
        $id = Auth::id();
        $user = User::find($id);
        /** temporarary IP localhost */
        $event_operation = "127.0.0.1";
        $data = DB::select(
            'CALL  spSaveDist_Data(?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
            array(
                $user->username,
                $filter_group,
                $lower_age,
                $upper_age,
                $data_card_type,
                $selected_level,
                $status_data1,
                $status_data2,
                $total_dist,
                $user_dist,
                $campaign,
                $zipcode,
                $gender,
                $event_operation
            )
        );
        return response()->json($data);
    }

    /** ============== batas akhir cotroller distribution data*===========================*/


    /** -------------- batas awal contoller ReCall/reload data ------------------------ */


    public function recall()
    {
        $id = Auth::id();
        $user = User::find($id);
        $criteria = 'CAMPAIGN_RELOAD';
        $Campaign = DB::select(
            'CALL  spComboboxReload(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                "",
                ""
            )
        );

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

        return view('recall-data.recall-data', compact('Campaign','user',
        'MENU_ADMIN','MENU_SPV','MENU_ATM','MENU_QA','MENU_SPVQA'));
    }

    public function checktotaldata(Request $request)
    {
        $id = Auth::id();
        $user = User::find($id);
        $criteria = 'CAMPAIGN_RELOAD_STATUSDATA_SUMMARY';
        $Campaign = $request->campaign;
        $data = DB::select(
            'CALL  spComboboxReload(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                $Campaign,
                ""
            )
        );

        return response()->json($data);
    }

    public function checkstatusdata(Request $request)
    {
        $id = Auth::id();
        $user = User::find($id);
        $criteria = 'CAMPAIGN_RELOAD_STATUSDATA';
        $Campaign = $request->campaign;
        $selectlevel = $request->selectlevel;
        $data = DB::select(
            'CALL  spComboboxReload(?,?,?,?)',
            array(
                $criteria,
                $user->username,
                $Campaign,
                $selectlevel
            )
        );

        return response()->json($data);
    }


    public function recall_list(Request $request)
    {
        if ($request->status == 'Fresh Data') {
            $status = "";
            $detail = "";
        } else {
            $status = $request->status;
            $detail = $request->detail;
        }


        $id = Auth::id();
        $user = User::find($id);
        $criteria = 'RELOAD';
        $Campaign = $request->campaign;
        $selectlevel = $request->selectlevel;
        $data = DB::select(
            'CALL  spGetReload_List(?,?,?,?,?,?)',
            array(
                $criteria,
                $user->username,
                $selectlevel,
                $Campaign,
                $status,
                $detail
            )
        );

        return response()->json($data);
    }

    public function process_recall(Request $request)
    {

        $Campaign = $request->campaign;
        $selectlevel = $request->selectlevel;
        if ($request->status == 'Fresh Data') {
            $status = "";
            $detail = "";
        } else {
            $status = $request->status;
            $detail = $request->detail;
        }

        $user_reload = $request->user_reload;
        $data_reload = $request->data_reload;
        $event_operation = "127.0.0.1";
        $id = Auth::id();
        $user = User::find($id);
        $data = DB::select(
            'CALL  spSaveReload_Data(?,?,?,?,?,?,?,?)',
            array(
                $user->username,
                $Campaign,
                $selectlevel,
                $status,
                $detail,
                $user_reload,
                $data_reload,
                $event_operation
            )
        );

        return response()->json($data);
    }

    /** ============== batas akhir cotroller recall data*===========================*/

    /** -------------- batas awal contoller ReCall/reload data ------------------------ */

    public function newcustomerlist()
    {
        $id = Auth::id();
        $user = User::find($id);
        $criteria = 'CAMPAIGN_NEW_LIST';
        $Campaign = DB::select(
            'CALL  spComboboxCustomerList(?,?)',
            array(
                $criteria,
                $user->username,
            )
        );

        return view('New-CustomerLIst.new_customerlist', [
            'Campaign' => $Campaign
        ]);
    }

    public function checkcustomerlist(Request $request)
    {
        $id = Auth::id();
        $user = User::find($id);
        $criteria1 = "NEW";
        if ($request->campaign == "---ALL---") {
            $criteria2 = "%%";
        } else {
            $criteria2 = $request->campaign;
        }
        $data = DB::select(
            'CALL  spGetCustomer_List_New(?,?,?)',
            array(
                $criteria1,
                $criteria2,
                $user->username
            )
        );

        return response()->json($data);
    }
}
