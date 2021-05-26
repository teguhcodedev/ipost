<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Login</title>

    <!-- CSS -->
    <link rel="stylesheet" href="{{ asset('assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/vendors/iconfonts/ionicons/css/ionicons.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/vendors/iconfonts/typicons/src/font/typicons.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/vendors/iconfonts/flag-icon-css/css/flag-icon.min.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/vendors/css/vendor.bundle.base.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/vendors/css/vendor.bundle.addons.css') }}">
    <link rel="stylesheet" href="{{ asset('assets/css/shared/style.css') }}">
    <link rel="stylesheet" href="{{ asset('plugins/css/sweetalert.css') }}">
    <link rel="stylesheet" href="{{ asset('css/login/style.css') }}">
    <link rel="shortcut icon" href="{{ asset('icons/favicon.png') }}"/>
    <!-- End-CSS -->

  </head>
  <body>
    <div class="container-scroller">
      <div class="container-fluid page-body-wrapper full-page-wrapper">
        <div class="content-wrapper d-flex justify-content-center align-items-center auth login-page theme-one shadow">
      
          <div class="row w-100">
         
            <div class="col-lg-4 mx-auto">
              <div class="auto-form-wrapper">
                @if ($errors->any())
                <div class="alert alert-danger mb-5" id="errKu">
                        <ul >
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>           
                </div>
            @endif
                <div class="text-center">
               
                  <img class="rounded-circle" width="180px" src="{{ asset('images/logo/logo-99.png')}}" alt="logo-tele" style="margin-top:-150px"/>
               {{-- <h2>Chublife Telesystem</h2> --}}
                </div>
          
                @if($users != 0)
                <form action="{{ url('/verify_login') }}" method="post" name="login_form">
                  @csrf
                  <div class="form-group">
                    <label class="label">Username</label>
                    <div class="input-group">
                      <input type="text" class="form-control" name="username" placeholder="Username">
                      <div class="input-group-append">
                        <span class="input-group-text check-value" id="username_error"></span>
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="label">Password</label>
                    <div class="input-group">
                      <input type="password" class="form-control" name="password" placeholder="*********">
                      <div class="input-group-append">
                        <span class="input-group-text check-value" id="password_error"></span>
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <button class="btn btn-primary submit-btn btn-block">Masuk</button>
                  </div>
                </form>
                @else
                <form action="{{ url('/first_account') }}" method="post" name="create_form">
                  @csrf
                  <div class="form-group">
                    <label class="label">Username</label>
                    <div class="input-group">
                      <input type="text" class="form-control" name="username_2" placeholder="Enter Username....">
                      <div class="input-group-append">
                        <span class="input-group-text check-value" id="username_2_error"></span>
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="label">Fullname</label>
                    <div class="input-group">
                      <input type="text" class="form-control" name="fullname_2" placeholder="Enter Fullname ....">
                      <div class="input-group-append">
                        <span class="input-group-text check-value" id="fullname_2_error"></span>
                      </div>
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="label">Phone Number</label>
                    <div class="input-group">
                      <input type="text" class="form-control" name="phone" placeholder="Enter Fullname ....">
                      <div class="input-group-append">
                        <span class="input-group-text check-value" id="phone_error"></span>
                      </div>
                    </div>
                  </div>
              
                
                  <div class="form-group">
                    <label class="label">Password</label>
                    <div class="input-group">
                      <input type="password" class="form-control" name="password_2" placeholder="*********">
                      <div class="input-group-append">
                        <span class="input-group-text check-value" id="password_2_error"></span>
                      </div>
                    </div>
                  </div>
                  <div class="form-group">
                    <button class="btn btn-primary submit-btn btn-block">Register Administrator</button>
                  </div>
                </form>
                @endif
              </div>
          
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Javascript -->
    <script src="{{ asset('assets/vendors/js/vendor.bundle.base.js') }}"></script>
    <script src="{{ asset('assets/vendors/js/vendor.bundle.addons.js') }}"></script>
    <script src="{{ asset('assets/js/shared/off-canvas.js') }}"></script>
    <script src="{{ asset('assets/js/shared/misc.js') }}"></script>
    <script src="{{ asset('plugins/js/jquery.form-validator.min.js') }}"></script>
    <script src="{{ asset('plugins/js/sweetalert.min.js') }}"></script>
    <script src="{{ asset('js/login/script.js') }}"></script>
    <script type="text/javascript">

      $("#errKu").show().delay(2500).fadeOut();
      @if ($message = Session::get('create_success'))
        swal(
            "Berhasil!",
            "{{ $message }}",
            "success"
        );
      @endif


      @if ($message = Session::get('is_banned'))
        swal(
            "Gagal",
            "{{ $message }}",
            "error"
        );
      @endif

      @if ($message = Session::get('login_failed'))
        swal(
            "Gagal!",
            "{{ $message }}",
            "error"
        );
      @endif
    </script>
    <!-- End-Javascript -->

  </body>
</html>