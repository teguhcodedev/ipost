<?php

namespace App\Helpers;

class SiteHelpers
{
    public static function notelp($telp)
    {
        // kadang ada penulisan no hp 0811 239 345
        $telp = str_replace(" ", "", $telp);
        // kadang ada penulisan no hp (0274) 778787
        $telp = str_replace("(", "", $telp);
        // kadang ada penulisan no hp (0274) 778787
        $telp = str_replace(")", "", $telp);
        // kadang ada penulisan no hp 0811.239.345
        $telp = str_replace(".", "", $telp);
        // kadang ada penulisan no hp 0811-239-345
        $telp = str_replace("-", "", $telp);
        //kadang ada penulisan no hp 0811-239-345

        if (substr(trim($telp), 0, 2) == '62') {
            $telp = substr_replace($telp, '0', 0, 2);
        } elseif (substr(trim($telp), 0, 3) == '+62') {
            $telp = substr_replace($telp, '0', 0, 3);
        }


        return  $telp;
    }
}
