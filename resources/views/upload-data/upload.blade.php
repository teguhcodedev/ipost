@extends('templates/main')
@section('css')
    <link rel="stylesheet" href="{{ asset('css/manage_product/product/style.css') }}">
@endsection
@section('content')
    <div class="row page-title-header">
        <div class="col-12">
            <div class="page-header d-flex justify-content-between align-items-center">
                <h4 class="page-title font-weight-bold">Upload Data</h4>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-8 col-md-12 col-sm-12 mb-4">
            <div class="card card-noborder b-radius">
                <div class="card-body">
                    @if ($temp_preview->count() > 0)
                        <div class="alert alert-primary d-flex justify-content-between align-items-center" role="alert">
                            <div class="text-instruction">
                                <i class="mdi mdi-information-outline mr-2"></i> silahkan klik button upload untuk upload
                                data ke databasa
                            </div>
                            <a href="{{ url('/upload/export_excel') }}" class="btn stok-btn"><i
                                    class="mdi mdi-printer"></i>Export
                                Data</a>
                        </div>
                    @else
                        <div class="alert alert-info d-flex justify-content-between align-items-center" role="alert">
                            <div class="text-info">
                                <i class="mdi mdi-information-outline mr-2"></i> pilih file dan klik import preview terlebih
                                dahulu
                                untuk preview data
                                upload
                            </div>
                        </div>
                    @endif

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered">
                            <tr>
                                {{-- <th class="text-center" scope="col">NO.</th> --}}
                                <th class="text-center" scope="col">Status</th>
                                <th class="text-center" scope="col">Id</th>
                                <th class="text-center" scope="col">Name</th>
                                <th class="text-center" scope="col">Mphone</th>
                                <th class="text-center" scope="col">Bphone</th>
                                <th class="text-center" scope="col">Hphone</th>
                                <th class="text-center" scope="col">Sex</th>
                                <th class="text-center" scope="col">Agenow</th>
                                <th class="text-center" scope="col">Zipcode</th>
                                <th class="text-center" scope="col">Jenis Kartu</th>

                            </tr>
                            @foreach ($temp_preview as $item)
                                <tr>
                                    {{-- <th class="text-center">{{ $loop->iteration }}</th> --}}
                                    {{-- <td class="text-center" scope="row">{{ $datalevels->firstItem() + $no }}</td> --}}
                                    {{-- <td class="text-center">{{ $item->status_upload }}</td> --}}
                                    @if ($item->status_upload == '')
                                        <td class="text-center">{{ $item->status_upload }}</td>
                                    @elseif ($item->status_upload == 'Success Upload Data!!')
                                        <td class="text-center  text-success">{{ $item->status_upload }}</td>
                                    @elseif($item->status_upload == 'Data Not Complete!!' )
                                        <td class="text-center text-warning">{{ $item->status_upload }}</td>
                                    @else
                                        <td class="text-center text-danger">{{ $item->status_upload }}</td>
                                    @endif
                                    <td class="text-center">{{ $item->cust_id }}</td>
                                    <td class="text-center">{{ $item->name }}</td>
                                    <td class="text-center">{{ $item->mphone }}</td>
                                    <td class="text-center">{{ $item->bphone }}</td>
                                    <td class="text-center">{{ $item->hphone }}</td>
                                    <td class="text-center">{{ $item->sex }}</td>
                                    <td class="text-center">{{ $item->agenow }}</td>
                                    <td class="text-center">{{ $item->zipcode }}</td>
                                    <td class="text-center">{{ $item->jenis_kartu }}</td>
                                </tr>
                            @endforeach
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-12 col-sm-12">
            <div class="row">
                <div class="col-12 stretch-card bg-dark-blue">
                    <div class="card text-black card-noborder b-radius">
                        <div class="card-body">
                            <div class="title">
                                <h5 class="title font-weight-bold">IMPORT DATA</h5>
                            </div>
                            <form action="{{ url('/upload/import') }}" method="POST" enctype="multipart/form-data">
                                @csrf
                                <div>
                                    <input type="file" name="file" class="form-control" required accept=".xls, .xlsx">
                                    @if ($errors->has('file'))
                                        <div class="alert-danger">
                                            {{ $errors->first('file') }}
                                        </div>
                                    @endif
                                </div>
                                <div class="card-footer">
                                    <button type="submit" class="btn btn-info">import to preview</button>
                                </div>
                            </form>
                            {{-- batas --}}
                            <form action="{{ url('/upload/uploaddata') }}" method="post" name="upload_form">
                                @csrf
                                <div class="form-group row">
                                    <label for="sponsor"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Sponsor</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="sponsor" id="sponsor">
                                            <option value="PARTNER">PARTNER</option>
                                            <option value="NON PARTNER">NON PARTNER</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="product_group"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Product
                                        Group</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="product_group" id="product_group">
                                            <option value="ALL">ALL</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="customer_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Customer
                                        Type</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="customer_type" id="customer_type">
                                            <option value="SAVING">SAVING</option>
                                            <option value="CREDIT CARD">CREDIT CARD</option>
                                        </select>
                                    </div>
                                    <label for="customer_type_detail"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold"></label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="customer_type_detail" id="customer_type_detail">
                                            <option value="REGULAR">REGULAR</option>
                                            <option value="SAP">SAP</option>
                                            <option value="PLATINUM">PLATINUM</option>
                                            <option value="REGULAR">S2S</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="data_card_type"
                                        class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Data Card
                                        Type</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <select class="form-control" name="data_card_type" id="data_card_type">
                                            <option value="SILVER">SILVER</option>
                                            <option value="GOLD">GOLD</option>
                                            <option value="PLATINUM">PLATINUM</option>
                                            <option value="TITANIUM">TITANIUM</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-lg-5 col-md-3 col-sm-12 col-form-label font-weight-bold">Campaign
                                        Name</label>
                                    <div class="col-lg-7 col-md-9 col-sm-12">
                                        <input type="text" class="form-control" name="campaign_name" id="campaign_name"
                                            required>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <input type="checkbox" class="form-control col-md-1 col-sm-12 col-form-label"
                                        name="unlimited_exp_date" id="unlimited_exp_date">
                                    <label class="col-md-11 col-sm-12 col-form-label font-weight-bold">Unlimited
                                        Exp. Date</label>
                                </div>
                                <div class="form-group row">
                                    <input type="checkbox" class="form-control col-md-1 col-sm-12 col-form-label"
                                        name="bypass_duplicate_data" id="bypass_duplicate_data">
                                    <label class="col-md-11 col-sm-12 col-form-label font-weight-bold">Bypass Duplicate
                                        Data</label>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-update"><i class="mdi mdi-upload"></i>
                                        Upload Data</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
@section('script')
    <script src="{{ asset('plugins/js/quagga.min.js') }}"></script>
    <script src="{{ asset('js/manage_product/product/script.js') }}"></script>
    <script type="text/javascript">
        @if ($message = Session::get('create_failed'))
            swal(
            "",
            "{{ $message }}",
            "error"
            );
        @endif
        @if ($message = Session::get('create_success'))
            swal(
            "Berhasil!",
            "{{ $message }}",
            "success"
            );
        @endif

        @if ($message = Session::get('update_success'))
            swal(
            "Berhasil!",
            "{{ $message }}",
            "success"
            );
        @endif

        @if ($message = Session::get('delete_success'))
            swal(
            "Berhasil!",
            "{{ $message }}",
            "success"
            );
        @endif

        @if ($message = Session::get('import_success'))
            swal(
            "Berhasil!",
            "{{ $message }}",
            "success"
            );
        @endif

        @if ($message = Session::get('update_failed'))
            swal(
            "",
            "{{ $message }}",
            "error"
            );
        @endif
        @if ($message = Session::get('notif_warning'))
            swal({
            title: "",
            text: "{{ $message }}",
            icon: "warning"
            })
        @endif

    </script>
@endsection
