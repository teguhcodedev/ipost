@extends('templates/main')
@section('css')
    <link rel="stylesheet" href="{{ asset('css/manage_product/supply_product/new_supply/style.css') }}">
    <link rel="stylesheet" href="{{ asset('css/manage_product/new_product/style.css') }}">
@endsection
@section('content')
    <div class="row page-title-header">
        <div class="col-12">
            <div class="page-header d-flex justify-content-start align-items-center">
                <div class="quick-link-wrapper d-md-flex flex-md-wrap">
                    <div class="title">
                        <h4 class="title font-weight-bold">Distribution Data</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-4 col-md-12 col-sm-12 mb-4">
            <div class="row">
                <div class="col-12">
                    <div class="card card-noborder b-radius">
                        <div class="card-body">
                            <form action="" method="post" name="ditribution _form">
                                @csrf
                                <div class="form-group row">
                                    <label for="product_group"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Product
                                        Group</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control product-group" name="product_group" title="Product Grup"
                                            id="product_group" required>
                                            <option value="" disabled="true" selected="true">-Select Product Grup-</option>
                                            @foreach ($ProductGroup as $item)
                                                <option value="{{ $item->JENIS_CUSTOMER }}">{{ $item->JENIS_CUSTOMER }}
                                                </option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="customer_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Campaign
                                        Name</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control campaign-name" title="Campaign Name"
                                            name="campaign_name" id="campaign_name" required>

                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row" id="test">
                                    <label for="data_card_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Status
                                        Data</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control status-data" title="Status Data" name="status_data"
                                            id="status_data" required>

                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="data_card_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Filter Group
                                        by</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control filter-group" title="Filter Group By"
                                            name="filter_group" id="filter_group" required>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group row" id="filter_age" hidden="">
                                    <label for="data_card_type" class="col-lg-5 col-form-label font-weight-bold"></label>
                                    <div class="col-lg-3 col-md-9 col-sm-12">
                                        <input type="number" min="0" pattern="\d*" style="height: 3rem;"
                                            class="form-control number-mutlak" name="upper_age" id="lower_age"
                                            title="lower limit" required>
                                    </div>
                                    <div class="col-lg-1">
                                        <h3>-</h3>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="number" min="0" pattern="\d*" style="height: 3rem;"
                                            class="form-control number-mutlak" name="upper_age" id="upper_age"
                                            title="upper limit" required>
                                    </div>
                                </div>

                                <div class="form-group row" id="filter_data_card_type" hidden="">
                                    <label for="data_card_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold"></label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="data_card_type" title="Type Of Card"
                                            id="data_card_type" required>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group row" id="filter_zipcode" hidden="">
                                    <label class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold"></label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <input type="text" class="form-control" placeholder="input zipcode" name="zipcode"
                                            id="zipcode" required title="zipcode">
                                    </div>
                                </div>

                                <div class="form-group row" id="filter_gender" hidden="">
                                    <label for="data_card_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold"></label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="gender" id="gender" title="Gender" required>
                                        </select>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="submit" title="Check" class="btn btn-search cari-distribution"><i
                                            class="mdi mdi-magnify"></i>
                                        Check</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-8 col-md-12 col-sm-12">
            <div class="card card-noborder b-radius">
                <div class="card-body">
                    <div class="form-group row">
                        <label for="total_data" class="col-lg-2 col-form-label font-weight-bold">Total
                            Data </label>
                        <div class="col-lg-3">
                            <input type="text" class="form-control" name="total_data" title="Total Data"
                                placeholder="Total Data" id="total_data" readonly="">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="selectlevel" class="col-lg-2 col-form-label font-weight-bold">Level</label>
                        <div class="col-lg-3">
                            <select class="form-control selectlevel" name="selectlevel" id="selectlevel" disabled="">
                                <option value="0" disabled="true" selected="true">-Select Level-</option>
                                @if ('administrator' == $user->role || 'admin' == $user->role){
                                    <option value="MANAGER">MANAGER</option>
                                    <option value="SPV">SPV</option>
                                    <option value="AGENT">AGENT</option>
                                    }
                                @elseif ('manager' == $user->role)
                                    <option value="SPV">SPV</option>
                                    <option value="AGENT">AGENT</option>
                                @elseif ('spv' == $user->role)
                                    <option value="AGENT">AGENT</option>
                                @endif
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-lg-3">
                            <input type="text" class="form-control" name="length_list" id="length_list" readonly=""
                                hidden="">
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-12 d-flex justify-content-end">
                            <button type="submit" class="btn btn-search process-distribution" title="Process"
                                id="btn_procces"><i class="mdi mdi-content-save"></i>
                                Process</button>
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered ditribution-list">
                                <thead>
                                    <tr>
                                        <th class="text-center">USER ID</th>
                                        <th class="text-center">USER NAME</th>
                                        <th class="text-center">TOTAL DIST</th>
                                        <th class="text-center">LEAD DATA</th>
                                        <th class="text-center">SPV ID</th>
                                        <th class="text-center">MANAGER ID</th>
                                    </tr>
                                </thead>
                                <tbody>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
@section('script')
    <script src="{{ asset('plugins/js/quagga.min.js') }}"></script>
    <script src="{{ asset('js/manage_product/new_product/script.js') }}"></script>
    <script src="{{ asset('js/distribution/script.js') }}"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#product_group").prop("selectedIndex", 0);
            $("#filter_group").prop("selectedIndex", 0);
            $("#selectlevel").prop("selectedIndex", 0);
            $('input[name=total_data]').val('');
            $('input[name=lower_age]').val('0');
            $('input[name=upper_age]').val('0');
            $('#selectlevel').attr('disabled', true);
            $('#btn_procces').attr('disabled', true);

            $(document).on('change', '.product-group', function() {
                //console.log("hmm its change");

                var product = $(this).val();
                //console.log(product);
                var div = $(this).parent();
                var op = " ";
                $.ajax({
                    url: "{{ url('/distribution/combocampaign') }}",
                    method: "GET",
                    data: {
                        'product': product
                    },
                    dataType: 'json',
                    success: function(data) {
                        //console.log('success');
                        //console.log(data);
                        //console.log(data.length);
                        if (data) {
                            $("#campaign_name").empty();
                            op = '<option value="" disabled="true" selected="true">-Select Campaign Name-</option>'
                            for (var i = 0; i < data.length; i++) {
                                op += '<option value="' + data[i].CAMPAIGN_NAME + '">' + data[i]
                                    .CAMPAIGN_NAME + '</option>';
                            }
                            $("#campaign_name").append(op);

                        } else {
                            $("#campaign_name").empty();
                        }

                    }
                });
            });

            $(document).on('change', '.campaign-name', function() {
                //console.log("hmm its change");
                $('#selectlevel').attr('disabled', true);
                $('#btn_procces').attr('disabled', true);
                var campaign = $(this).val();
                //console.log(product);
                var div = $(this).parent();
                var op = " ";
                $.ajax({
                    url: "{{ url('/distribution/combostatusdata') }}",
                    method: "GET",
                    data: {
                        'campaign': campaign
                    },
                    dataType: 'json',
                    success: function(data) {
                        //console.log('success');
                        //console.log(data);
                        //console.log(data.length);
                        if (data) {
                            $("#status_data").empty();
                            op = '<option value="" disabled="true" selected="true">-Select Status Data-</option>'
                            for (var i = 0; i < data.length; i++) {
                                op += '<option value="' + data[i].CBO + '">' + data[i].CBO +
                                    '</option>';
                            }
                            $("#status_data").append(op);
                        } else {
                            $("#status_data").empty();
                        }

                    }
                });
            });

            $(document).on('change', '.status-data', function() {
                $('#selectlevel').attr('disabled', true);
                $('#btn_procces').attr('disabled', true);
                var div = $(this).parent();
                var op = " ";
                $.ajax({
                    success: function() {
                        var data = [{
                                id: 0,
                                text: '---ALL---'
                            },
                            {
                                id: 1,
                                text: 'Age'
                            },
                            {
                                id: 2,
                                text: 'Type Of Card'
                            },
                            {
                                id: 3,
                                text: 'Zipcode'
                            },
                            {
                                id: 4,
                                text: 'Gender'
                            }
                        ];
                        if (data) {
                            $("#filter_group").empty();
                            op = '<option value="" disabled="true" selected="true">-Select Filter Group By-</option>'
                            for (var i = 0; i < data.length; i++) {
                                op += '<option value="' + data[i].text + '">' + data[i].text +
                                    '</option>';
                            }
                            $("#filter_group").append(op);
                        } else {
                            $("#filter_group").empty();
                        }

                    }
                });
            });

            $(document).on('change', '.filter-group', function() {
                //console.log("hmm its change");
                $('#selectlevel').attr('disabled', true);
                $('#btn_procces').attr('disabled', true);
                var filter = $(this).val();
                var campaign = $('#campaign_name').val();
                var div = $(this).parent();
                var op = " ";

                if (filter === 'Age') {
                    $('#filter_age').prop('hidden', false);

                    $('#filter_data_card_type').prop('hidden', true);
                    $('#filter_zipcode').prop('hidden', true);
                    $('#filter_gender').prop('hidden', true);
                } else if (filter === 'Type Of Card') {
                    $('#filter_data_card_type').prop('hidden', false);

                    $('#filter_age').prop('hidden', true);
                    $('#filter_zipcode').prop('hidden', true);
                    $('#filter_gender').prop('hidden', true);
                    $.ajax({
                        url: "{{ url('/distribution/checkfilter') }}",
                        method: "GET",
                        data: {
                            'filter': filter,
                            'campaign': campaign
                        },
                        dataType: 'json',
                        success: function(data) {
                            if (data) {
                                $("#data_card_type").empty();
                                op = '<option value="" disabled="true" selected="true">-Select Type Of Card-</option>'
                                for (var i = 0; i < data.length; i++) {
                                    op += '<option value="' + data[i].CBO + '">' +
                                        data[i].CBO + '</option>';
                                }
                                $("#data_card_type").append(op);
                            } else {
                                $("#data_card_type").empty();
                            }

                        }
                    });

                } else if (filter === 'Zipcode') {
                    $('#filter_zipcode').prop('hidden', false);

                    $('#filter_age').prop('hidden', true);
                    $('#filter_data_card_type').prop('hidden', true);
                    $('#filter_gender').prop('hidden', true);
                } else if (filter === 'Gender') {
                    $('#filter_gender').prop('hidden', false);

                    $('#filter_age').prop('hidden', true);
                    $('#filter_data_card_type').prop('hidden', true);
                    $('#filter_zipcode').prop('hidden', true);
                    $.ajax({
                        url: "{{ url('/distribution/checkfilter') }}",
                        method: "GET",
                        data: {
                            'filter': filter,
                            'campaign': campaign
                        },
                        dataType: 'json',
                        success: function(data) {
                            if (data) {
                                $("#gender").empty();
                                op = '<option value="" disabled="true" selected="true">-Select Gender-</option>'
                                for (var i = 0; i < data.length; i++) {
                                    op += '<option value="' + data[i].CBO + '">' + data[i].CBO +
                                        '</option>';
                                }
                                $("#gender").append(op);
                            } else {
                                $("#gender").empty();
                            }

                        }
                    });

                } else {
                    $('#filter_age').prop('hidden', true);
                    $('#filter_data_card_type').prop('hidden', true);
                    $('#filter_zipcode').prop('hidden', true);
                    $('#filter_gender').prop('hidden', true);
                }

            });

            $(document).on('click', '.cari-distribution', function() {
                $("#selectlevel").prop("selectedIndex", 0);
                var product_group = $('#product_group').val();
                var campaign = $('#campaign_name').val();
                var status_data = $('#status_data').val();
                var filter_group = $('#filter_group').val();
                var lower_age = $('#lower_age').val();
                var upper_age = $('#upper_age').val();
                var data_card_type = $('#data_card_type').val();
                var zipcode = $('#zipcode').val();
                var gender = $('#gender').val();
                $('input[name=total_data]').val('');
                $('input[name=length_list]').val('');
                var div = $(this).parent();
                var op = " ";
                $.ajax({
                    url: "{{ url('/distribution/checkdistribution') }}/",
                    method: "GET",
                    data: {
                        'product_group': product_group,
                        'campaign': campaign,
                        'status_data': status_data,
                        'filter_group': filter_group,
                        'lower_age': lower_age,
                        'upper_age': upper_age,
                        'data_card_type': data_card_type,
                        'zipcode': zipcode,
                        'gender': gender
                    },
                    dataType: 'json',
                    success: function(data) {
                        if (data) {
                            $('input[name=total_data]').val(data[0].TOTAL_DATA);
                            $('#selectlevel').attr('disabled', false);
                        }
                    }
                });
            });


            $(document).on('change', '.selectlevel', function() {
                $('tbody').empty();
                $('input[name=length_list]').val('');
                var selectlevel = $('#selectlevel').val();
                var campaign = $('#campaign_name').val();
                var div = $(this).parent();
                var op = " ";
                $.ajax({
                    url: "{{ url('/distribution/distribution_list') }}/",
                    method: "GET",
                    data: {
                        'campaign': campaign,
                        'selectlevel': selectlevel
                    },
                    dataType: 'json',
                    success: function(data) {
                        //console.log('success');
                        if (data) {
                            $('#btn_procces').attr('disabled', false);
                            $('tbody').empty();
                            $('input[name=length_list]').val(data.length);
                            for (var i = 0; i < data.length; i++) {
                                var SPV_ID = (data[i].SPV_ID == null) ? "-" :
                                    data[i].SPV_ID;
                                op += '<tr>' +
                                    '<td class="text-center">' +
                                    '<input type="text" class="form-control" name="user_dist' +
                                    i + '" id="user_dist' + i + '" value="' +
                                    data[i].AGENT_USERNAME + '" readonly="">' + '</td>' +
                                    '<td class="text-center">' + data[i].AGENT_NAME + '</td>' +
                                    '<td class="text-center">' +
                                    '<input type="number"  min="0" pattern="\d*" class="form-control" name="total_dist' +
                                    i + '" id="total_dist' + i + '" value="' +
                                    data[i].TOTAL_DIST + '">' + '</td>' +
                                    '<td class="text-center">' + data[i].LEAD_DATA + '</td>' +
                                    '<td class="text-center">' + SPV_ID + '</td>' +
                                    '<td class="text-center">' + data[i].MANAGER_ID + '</td>' +
                                    '</tr>';
                            }
                            $('tbody').append(op);
                            $('.btn-simpan').prop('hidden', false);
                        } else {
                            $('tbody').empty();
                        }

                    }
                });
            });

            $(document).on('click', '.process-distribution', function() {
                console.log("hmm its click");
                var campaign = $('#campaign_name').val();
                var status_data = $('#status_data').val();
                var filter_group = $('#filter_group').val();
                var lower_age = parseInt($('#lower_age').val());
                var upper_age = parseInt($('#upper_age').val());
                var data_card_type = $('#data_card_type').val();
                var zipcode = $('#zipcode').val();
                var gender = $('#gender').val();
                var total_data = parseInt($('#total_data').val());
                //console.log(total_data);
                var selectlevel = $('#selectlevel').val();
                //console.log(selectlevel);
                var length_list = parseInt($('#length_list').val());
                //console.log(length_list);
                var cektotal_dist = 0;
                var newdist = [];
                for (var y = 0; y < length_list; y++) {
                    var cekdist = parseInt($('#total_dist' + y).val());
                    if (cekdist >= 0) {
                        newdist.push(y);
                    }
                    cektotal_dist += parseInt($('#total_dist' + y).val());
                }
                //console.log(newdist.length);
                //console.log(length_list);
                //console.log(cektotal_dist);
                if (cektotal_dist <= total_data && cektotal_dist > 0 && length_list === newdist.length) {
                    swal({
                            title: "",
                            text: "Are You Sure to Distribute Data?",
                            icon: "warning",
                            buttons: true,
                        })
                        .then((willyes) => {
                            if (willyes) {
                                for (var i = 0; i < length_list; i++) {
                                    var user_dist = $('#user_dist' + i).val();
                                    //console.log(user_dist);
                                    var total_dist = $('#total_dist' + i).val();
                                    //console.log(total_dist);
                                    $.ajax({
                                        url: "{{ url('/distribution/process_distribution') }}/",
                                        method: "GET",
                                        data: {
                                            'campaign': campaign,
                                            'status_data': status_data,
                                            'filter_group': filter_group,
                                            'lower_age': lower_age,
                                            'upper_age': upper_age,
                                            'data_card_type': data_card_type,
                                            'zipcode': zipcode,
                                            'gender': gender,
                                            'user_dist': user_dist,
                                            'total_dist': total_dist,
                                            'selectlevel': selectlevel,
                                        },
                                        dataType: 'json',
                                        success: function(data) {
                                            //console.log('success');
                                            $("#product_group").prop("selectedIndex", 0);
                                            $("#campaign_name").empty();
                                            $("#status_data").empty();
                                            $("#filter_group").empty();
                                            $('input[name=lower_age]').val('0');
                                            $('input[name=upper_age]').val('0');
                                            $("#data_card_type").empty();
                                            $('input[name=zipcode]').val('');
                                            $("#gender").empty();
                                            $('input[name=total_data]').val('');
                                            $("#selectlevel").prop("selectedIndex", 0);
                                            $('#selectlevel').attr('disabled', true);
                                            $('input[name=length_list]').val('');
                                            $('tbody').empty();
                                            $('#btn_procces').attr('disabled', true);
                                            $('#filter_age').prop('hidden', true);
                                            $('#filter_data_card_type').prop('hidden',
                                                true);
                                            $('#filter_zipcode').prop('hidden', true);
                                            $('#filter_gender').prop('hidden', true);
                                            swal({
                                                title: "Success!",
                                                text: "Distribution Data Successfully!!",
                                                icon: "success",
                                            }).then((willsuccess) => {
                                                window.location.reload();
                                            });

                                        }
                                    });
                                }
                            }
                        });
                } else {
                    swal({
                        title: "Warning!",
                        text: "Please Fill Some Data to Distribution",
                        icon: "warning"
                    });
                }
            });
        });

    </script>
@endsection
