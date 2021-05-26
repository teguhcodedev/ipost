<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CustomerPreview extends Model
{
    protected $table = 'temp_preview_customers';
    // Initialize
    protected $fillable = [
        'name', 'mphone', 'bphone', 'hphone', 'sex', 'agenow', 'zipcode',
        'jenis_kartu', 'cust_id', 'status_upload', 'nama_campaign'
    ];
}
