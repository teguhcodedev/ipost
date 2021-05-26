@extends('templates/main')
@section('css')
    <link rel="stylesheet" href="{{ asset('css/manage_product/supply_product/new_supply/style.css') }}">
    <link rel="stylesheet" href="{{ asset('css/manage_product/new_product/style.css') }}">
    <style type="text/css">
        td {
            border: 1px #DDD solid;
            padding: 5px;
            cursor: pointer;
        }

        .selected {
            background-color: brown;
            color: #FFF;
        }

    </style>
@endsection
@section('content')
    <div class="row page-title-header">
        <div class="col-12">
            <div class="page-header d-flex justify-content-start align-items-center">
                <div class="quick-link-wrapper d-md-flex flex-md-wrap">
                    <div class="title">
                        <h4 class="title font-weight-bold">ReCall Data</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="card card-noborder b-radius">
                <div class="card-body">
                    <div class="col-lg-12 col-md-12 col-sm-12 row">
                        <div class="col-lg-6 col-md-6 col-sm-12 form-group row">
                            <label for="campaign_name"
                                class="col-lg-3 col-md-3 col-sm-12 col-form-label font-weight-bold">Campaign Name</label>
                            <div class="col-lg-6 col-md-6 col-sm-12">
                                <select class="form-control campaign-name" name="campaign_name" title="Campaign Name"
                                    id="campaign_name" required>
                                    <option value="" disabled="true" selected="true">-Select Campaign Name-</option>
                                    @foreach ($Campaign as $item)
                                        <option value="{{ $item->CBO }}">{{ $item->CBO }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-12 form-group row">
                            <label for="total_data"
                                class="col-lg-3 col-md-3 col-sm-12 col-form-label font-weight-bold">Total
                                Data </label>
                            <div class="col-lg-6 col-md-6 col-sm-12">
                                <input type="text" class="form-control" name="total_data" title="Total Data"
                                    placeholder="Total Data" id="total_data" readonly="">
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-12 form-group row">
                            <label for="selectlevel"
                                class="col-lg-3 col-md-3 col-sm-12  col-form-label font-weight-bold">Level</label>
                            <div class="col-lg-6 col-md-6 col-sm-12 ">
                                <select class="form-control selectlevel" name="selectlevel" id="selectlevel" disabled="">
                                    <option value="0" disabled="true" selected="true">-Select Level-</option>
                                    @if ('administrator' == $user->role){
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
                    </div>
                    <div class="form-group row">
                        <div class="col-12 d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary process-recall" title="ReCall" id="btn_recall"
                                disabled="true"><i class="mdi mdi-reply-all"></i>
                                ReCall</button>
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-lg-2">
                            <input type="text" class="form-control" name="status" id="status" readonly="">
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class="form-control" name="detail" id="detail" readonly="">
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class="form-control" name="userid" id="userid" readonly="">
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class="form-control" name="data_recall" id="data_recall" readonly="">
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-lg-5">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered " id="statusdata">
                                    <thead>
                                        <tr>
                                            <th class="text-center">STATUS</th>
                                            <th class="text-center">DETAIL STATUS</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tabel_statusdata">

                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered ditribution-list">
                                    <thead>
                                        <tr>
                                            <th class="text-center">USER ID</th>
                                            <th class="text-center">USER NAME</th>
                                            <th class="text-center">LEAD DATA</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tabel_reload_list">

                                    </tbody>
                                </table>
                            </div>
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
            $("#campaign_name").prop("selectedIndex", 0);
            $("#selectlevel").prop("selectedIndex", 0);
            $('#selectlevel').attr('disabled', true);
            $('input[name=total_data]').val('');

            $('#tabel_statusdata').empty();
            $('#tabel_reload_list').empty();

            $('input[name=status]').val('');
            $('input[name=detail]').val('');
            $('input[name=userid]').val('');
            $('input[name=data_recall]').val('');

            $('#btn_recall').attr('disabled', true);

            $(document).on('change', '.campaign-name', function() {
                $('#selectlevel').attr('disabled', false);
                $("#selectlevel").prop("selectedIndex", 0);

                $('#btn_procces').attr('disabled', true);

                $('#tabel_statusdata').empty();
                $('#tabel_reload_list').empty();

                $('input[name=status]').val('');
                $('input[name=detail]').val('');
                $('input[name=userid]').val('');
                $('input[name=data_recall]').val('');

                var campaign = $(this).val();
                var op = " ";
                $.ajax({
                    url: "{{ url('/recall/checktotaldata') }}/",
                    method: "GET",
                    data: {
                        'campaign': campaign,
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
                $('#btn_procces').attr('disabled', true);

                $('#tabel_statusdata').empty();
                $('#tabel_reload_list').empty();

                $('input[name=status]').val('');
                $('input[name=detail]').val('');
                $('input[name=userid]').val('');
                $('input[name=data_recall]').val('');

                var selectlevel = $('#selectlevel').val();
                var campaign = $('#campaign_name').val();
                var div = $(this).parent();
                var op = " ";
                $.ajax({
                    url: "{{ url('/recall/checkstatusdata') }}/",
                    method: "GET",
                    data: {
                        'campaign': campaign,
                        'selectlevel': selectlevel
                    },
                    dataType: 'json',
                    success: function(data) {
                        //console.log('success');
                        if (data) {
                            $('#tabel_statusdata').empty();
                            for (var i = 0; i < data.length; i++) {
                                op += '<tr data-status="' + data[i].STATUS +
                                    '" data-detail="' + data[i].DETAIL_STATUS +
                                    '" class="trselectstatus">' +
                                    '<td class="text-center">' + data[i].STATUS +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].DETAIL_STATUS +
                                    '</td>' +
                                    '</tr>';
                            }
                            $('#tabel_statusdata').append(op);
                        } else {
                            $('#tabel_statusdata').empty();

                            $('#tabel_reload_list').empty();
                            $('input[name=status]').val('');
                            $('input[name=detail]').val('');
                            $('input[name=userid]').val('');
                            $('input[name=data_recall]').val('');
                        }

                    }
                });
            });
            $(document).on('click', '.trselectstatus', function() {
                $('.trselect').not(this).css('backgroundColor', "#FFF");
                $(this).css('backgroundColor', "#FAA");

                $('#tabel_reload_list').empty();
                $('input[name=status]').val('');
                $('input[name=detail]').val('');
                $('input[name=userid]').val('');
                $('input[name=data_recall]').val('');


                var status = $(this).attr('data-status');
                var detail = $(this).attr('data-detail');
                var selectlevel = $('#selectlevel').val();
                var campaign = $('#campaign_name').val();
                var op = " ";
                $.ajax({
                    url: "{{ url('/recall/recall_list') }}/",
                    method: "GET",
                    data: {
                        'campaign': campaign,
                        'selectlevel': selectlevel,
                        'status': status,
                        'detail': detail,
                    },
                    dataType: 'json',
                    success: function(data) {
                        if (data) {
                            console.log('sukses')
                            $('#btn_procces').attr('disabled', false);
                            $('#tabel_reload_list').empty();
                            for (var i = 0; i < data.length; i++) {
                                op += '<tr class="trselectagent" data-userid="' +
                                    data[i].AGENT_USERNAME +
                                    '" data-recall="' + data[i].LEAD_DATA + '">' +
                                    '<td class="text-center">' + data[i].AGENT_USERNAME +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].AGENT_NAME +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].LEAD_DATA +
                                    '</td>' +
                                    '</tr>';
                            }
                            $('#tabel_reload_list').append(op);
                            $('input[name=status]').val(status);
                            $('input[name=detail]').val(detail);
                        } else {
                            $('#tabel_reload_list').empty();
                            $('input[name=status]').val('');
                            $('input[name=detail]').val('');
                            $('input[name=userid]').val('');
                            $('input[name=data_recall]').val('');
                        }
                    }
                });


            });

            $(document).on('click', '.trselectagent', function() {
                $('.trselectagent').not(this).css('backgroundColor', "#FFF");
                $(this).css('backgroundColor', "#FAA");

                $('input[name=userid]').val('');
                $('input[name=data_recall]').val('');

                var userid = $(this).attr('data-userid');
                var data_reload = $(this).attr('data-recall');

                $('input[name=userid]').val(userid);
                $('input[name=data_recall]').val(data_reload);

                $('#btn_recall').attr('disabled', false);
            });


            $(document).on('click', '.process-recall', function() {
                $('.trselectagent').not(this).css('backgroundColor', "#FFF");
                $(this).css('backgroundColor', "#FAA");
                var campaign = $('#campaign_name').val();
                var selectlevel = $('#selectlevel').val();
                var status = $('#status').val();
                var detail = $('#detail').val();
                var user_reload = $('#userid').val();

                var data_recall = parseInt($('#data_recall').val());
                if (userid != null && data_recall > 0) {
                    swal({
                            title: "",
                            text: "Are You Sure to Reload Data?",
                            icon: "warning",
                            buttons: true,
                        })
                        .then((willyes) => {
                            if (willyes) {
                                $.ajax({
                                    url: "{{ url('/recall/process_recall') }}/",
                                    method: "GET",
                                    data: {
                                        'campaign': campaign,
                                        'selectlevel': selectlevel,
                                        'status': status,
                                        'detail': detail,
                                        'user_reload': user_reload,
                                        'data_reload': data_recall
                                    },
                                    dataType: 'json',
                                    success: function(data) {
                                        $("#campaign_name").prop("selectedIndex", 0);
                                        $("#selectlevel").prop("selectedIndex", 0);
                                        $('#selectlevel').attr('disabled', true);
                                        $('input[name=total_data]').val('');

                                        $('#tabel_statusdata').empty();
                                        $('#tabel_reload_list').empty();

                                        $('input[name=status]').val('');
                                        $('input[name=detail]').val('');
                                        $('input[name=userid]').val('');
                                        $('input[name=data_recall]').val('');
                                        $('#btn_recall').attr('disabled', true);
                                    }
                                });
                                swal({
                                    title: "Success!",
                                    text: "Reload Data Successfully!!",
                                    icon: "success",
                                }).then((willsuccess) => {
                                    window.location.reload();
                                });
                            }
                        });
                } else {
                    swal({
                        title: "Warning!",
                        text: "Please check Data to Reload",
                        icon: "warning"
                    });
                }

            });


        });

    </script>
@endsection
