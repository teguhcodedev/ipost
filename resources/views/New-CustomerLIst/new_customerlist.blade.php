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
                        <div class="col-lg-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered new-list">
                                    <thead>
                                        <tr>
                                            <th class="text-center">ID</th>
                                            <th class="text-center">CUST APPID</th>
                                            <th class="text-center">CUST NAME</th>
                                            <th class="text-center">AGENT ID</th>
                                            <th class="text-center">JENIS CUSTOMER</th>
                                            <th class="text-center">CAMPAIGN NAME</th>
                                            <th class="text-center">UPLOAD DATE</th>
                                            <th class="text-center">EXPIRE DATE</th>
                                            <th class="text-center">DISTRIBUTE DATE</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tabel_new_list">

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
            $('input[name=total_data]').val('');

            $(document).on('change', '.campaign-name', function() {
                console.log('click nang kene');
                $('input[name=total_data]').val(' ');
                var campaign = $(this).val();
                console.log(campaign);
                var op = " ";
                $.ajax({
                    url: "{{ url('newcustomerlist/checkcustomerlist') }}/",
                    method: "GET",
                    data: {
                        'campaign': campaign,
                    },
                    dataType: 'json',
                    success: function(data) {
                        //console.log('success');
                        //console.log(data);
                        //console.log(data.length);
                        if (data) {
                            $('input[name=total_data]').val(data.length);
                            $('#tabel_new_list').empty();
                            for (var i = 0; i < data.length; i++) {
                                op += '<tr class="trselectnewlist" data-nama="' +
                                    data[i].CUST_NAME + '">' +
                                    '<td class="text-center">' + data[i].ID +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].CUST_APPID +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].CUST_NAME +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].AGENT_USERNAME +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].JENIS_CUSTOMER +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].CAMPAIGN_NAME +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].UPLOAD_DATE +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].EXPIRE_DATE +
                                    '</td>' +
                                    '<td class="text-center">' + data[i].DISTRIBUTE_DATE +
                                    '</td>' +
                                    '</tr>';
                            }
                            $('#tabel_new_list').append(op);
                        } else {
                            $('input[name=total_data]').val('');
                            $('#tabel_new_list').empty();
                        }
                    }
                });

            });

            $(document).on('click', '.trselectnewlist', function() {
                $('.trselectnewlist').not(this).css('backgroundColor', "#FFF");
                $(this).css('backgroundColor', "#FAA");
                var cust_name = $(this).attr('data-nama');
                alert('klick cust : ' + cust_name);
            });

        });

    </script>
@endsection
