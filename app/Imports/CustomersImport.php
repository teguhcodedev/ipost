<?php

namespace App\Imports;

use App\Customer;
use App\Helpers\SiteHelpers;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Schema;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use Illuminate\Support\Facades\DB;



class CustomersImport implements ToCollection, WithHeadingRow
{
    public function collection(Collection $collection)
    {
        foreach ($collection as $row) {
            $mphone = SiteHelpers::notelp($row['mphone']);
            $bphone = SiteHelpers::notelp($row['bphone']);
            $hphone = SiteHelpers::notelp($row['hphone']);
            DB::select(
                'CALL  insertPreview(?,?,?,?,?,?,?,?,?)',
                array(
                    $row['id'],
                    $row['name1'],
                    $mphone,
                    $bphone,
                    $hphone,
                    $row['sex'],
                    $row['agenow'],
                    $row['zipcode'],
                    $row['jenis_kartu']
                )
            );
        }
        //return dd($collection);
    }
}
