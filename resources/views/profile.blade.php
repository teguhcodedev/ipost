@extends('templates/main')
@section('css')
<link rel="stylesheet" href="{{ asset('css/profile/style.css') }}">
@endsection
@section('content')
<div class="row page-title-header">
  <div class="col-12">
    <div class="page-header d-flex justify-content-between align-items-center">
      <h4 class="page-title">Profile</h4>
    </div>
  </div>
</div>
<div class="row modal-group">
  <div class="modal fade" id="activityModal" tabindex="-1" role="dialog" aria-labelledby="activityModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="activityModalLabel">Activities History</h5>
          <button type="button" class="close close-btn" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <div class="form-group">
                <input type="text" class="form-control" name="search" placeholder="Cari barang">
              </div>  
            </div>
          
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-8 col-md-8 col-sm-6 col-12">
    <div class="card card-noborder b-radius">
      <div class="card-body">
        <div class="row">
          <div class="col-12 d-flex">
            <button class="btn-tab data_diri_tab_btn btn-tab-active">Change My Profile</button>
            <button class="btn-tab password_tab_btn">Change Password</button>
            <div class="btn-tab-underline"></div>
          </div>
          <div class="col-12 mt-3">
            <form name="change_profile_form" method="POST" action="{{ url('/profile/update/data') }}">
              @csrf
              
              <div class="form-group row">
                <label class="col-12 font-weight-bold col-form-label">Username <span class="text-danger">*</span></label>
                <div class="col-12">
                  <input type="text" class="form-control" name="username" placeholder="Enter username" value="{{  $MUA->AGENT_USERNAME }}">
                </div>
                <div class="col-12 error-notice" id="username_error"></div>
              </div>
                
                
                <div class="form-group row">
                  <label class="col-12 font-weight-bold col-form-label">Phone Number <span class="text-danger">*</span></label>
                  <div class="col-12">
                    <input type="text" class="form-control" name="dn" placeholder="Enter phone number" value="{{  $MUA->AGENT_DN }}">
                  </div>
                  <div class="col-12 error-notice" id="dn_error"></div>
                </div>

              <div class="form-group row">
                <label class="col-12 font-weight-bold col-form-label">Fullname <span class="text-danger">*</span></label>
                <div class="col-12">
                  <input type="text" class="form-control" name="fullname" placeholder="Enter fullname" value="{{  $MUA->AGENT_NAME }}">
                </div>
                <div class="col-12 error-notice" id="fullname_error"></div>
              </div>
            
              <div class="row mt-5">
                <div class="col-12 d-flex justify-content-end">
                  <button class="btn update-btn btn-sm" type="submit"><i class="mdi mdi-content-save"></i> Save Profile</button>
                </div>
              </div>
            </form>
            <form name="change_password_form" method="POST" action="{{ url('/profile/update/password') }}" hidden="">
              @csrf
              <div class="form-group row">
                <label class="col-12 font-weight-bold col-form-label">Old Password <span class="text-danger">*</span></label>
                <div class="col-12">
                  <input type="password" class="form-control" name="old_password" placeholder="Masukkan Password Lama">
                </div>
                <div class="col-12 error-notice" id="old_password_error"></div>
              </div>
              <div class="form-group row">
                <label class="col-12 font-weight-bold col-form-label">New Password <span class="text-danger">*</span></label>
                <div class="col-12">
                  <input type="password" class="form-control" name="new_password" placeholder="Masukkan Password Baru">
                </div>
                <div class="col-12 error-notice" id="new_password_error"></div>
              </div>
              <div class="row mt-5">
                <div class="col-12 d-flex justify-content-end">
                  <button class="btn update-btn btn-sm" type="submit"><i class="mdi mdi-content-save"></i> Ubah Password</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-lg-4 col-md-6 col-sm-6 account-detail mb-4 col-12">
    <div class="card card-noborder b-radius">
      <div class="card-body">
        <div class="row">
          <div class="col-12 text-center foto">
            <form name="change_picture_form" action="{{ url('/profile/update/picture') }}" method="POST" enctype="multipart/form-data">
              @csrf
              <img src="{{ asset('chubb_foto/' . $MUA->AGENT_PHOTO) }}" class="foto-profil">
              <input type="file" name="foto" id="foto" hidden="" accept=".png, .jpg, .jpeg">
              <button class="btn-edit-img" type="button"><i class="mdi mdi-pencil"></i></button>
              <button class="btn-update-img" type="submit" hidden=""><i class="mdi mdi-content-save"></i></button>
            </form>
          </div>
          <div class="col-12 mt-3 text-center">
            <p class="nama-akun">{{ $MUA->AGENT_USERNAME }}</p>
            <p class="posisi-akun">{{ $MUA->AGENT_LEVEL }}</p>
          </div>

          <div class="col-12 mt-3 d-flex justify-content-between align-items-start">
          <div class="d-flex justify-content-center align-items-center">
            <div class="icon mr-3">
              <i class="mdi mdi-account-card-details"></i>
             
            </div>
            <div class="text-group mr-2">
              <h6>Username</h6>
            </div>
            <div><h6>:</h6></div>
            <div class="text-group ml-3">
              <h5>{{ $MUA->AGENT_LEVEL }}</h5>
            </div>
          </div>
        </div>

        <div class="col-12 mt-3 d-flex justify-content-between align-items-start">
          <div class="d-flex justify-content-center align-items-center">
            <div class="icon mr-3">
              <i class="mdi mdi-account-outline"></i>
            </div>
            <div class="text-group mr-2">
              <h6>Fullname</h6>
            </div>
            <div><h6>:</h6></div>
            <div class="text-group ml-3">
              <h5>{{ $MUA->AGENT_NAME }}</h5>
            </div>
          </div>
        </div>

        <div class="col-12 mt-3 d-flex justify-content-between align-items-start">
          <div class="d-flex justify-content-center align-items-center">
            <div class="icon mr-3">
              <i class="mdi mdi-cellphone-android"></i>
            </div>
            <div class="text-group mr-4">
              <h6>Phone</h6>
            </div>
            <div><h6>:</h6></div>
            <div class="text-group ml-4">
              <h5>{{ $MUA->AGENT_DN }}</h5>
            </div>
          </div>
        </div>
          {{-- <div class="col-12 mt-5 d-flex justify-content-between">
            <p class="aktivitas-text">Aktivitas Terbaru</p>
            <div class="history-btn" data-toggle="modal" data-target="#activityModal">
              <i class="mdi mdi-history"></i>
            </div>
          </div>
          <div class="col-12">
            @foreach($activity as $act)
            <div class="text-group mt-2">
              <div class="d-flex justify-content-between">
                <p class="nama-aktivitas">{{ $act->nama_kegiatan }}</p>
                <span class="des-aktivitas">{{ date('d M', strtotime($act->created_at)) }}</span>
              </div>
              <p class="des-aktivitas">{{ date('H:i', strtotime($act->created_at)) }} <span class="dot"><i class="mdi mdi-checkbox-blank-circle"></i></span> {{ $act->jumlah }} Jenis Barang</p>
            </div>
            @endforeach
          </div> --}}
        </div>
      </div>
    </div>
  </div>
</div>
@endsection
@section('script')
<script src="{{ asset('js/profile/script.js') }}"></script>
<script type="text/javascript">
  @if ($message = Session::get('update_success'))
    swal(
      "Berhasil!",
      "{{ $message }}",
      "success"
    );
  @endif

  @if ($message = Session::get('update_error'))
    swal(
      "",
      "{{ $message }}",
      "error"
    );
  @endif
</script>
@endsection