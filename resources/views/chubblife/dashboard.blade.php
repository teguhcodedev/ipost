@extends('templates/main')
@section('css')
<link rel="stylesheet" href="{{ asset('css/dashboard/style.css') }}">
@endsection
@section('content')
<div class="row page-title-header">
  <div class="col-md-9">
    <div class="page-header d-flex justify-content-between align-items-center">
      <h4 class="page-title">Dashboard |
         @if (Auth::user()->role=="admin")
          ADMIN
      @elseif(Auth::user()->role=="spv")
          SPV
     @elseif(Auth::user()->role=="manager")
          MANAGER
      @elseif(Auth::user()->role=="qa")
          QA
      @endif
    </h4>
    </div>
  </div>
  <div class="col-md-3">
    <div class="page-header ">
     <div class="row d-flex justify-content-right">
      <h4 class="page-title">Total Page : 
        @if (Auth::user()->role=="admin")
           {{$TOTAL_MENU_ADMIN }}
        @elseif (Auth::user()->role=="spv")
           {{$TOTAL_MENU_SPV }}
        @elseif (Auth::user()->role=="manager")
           {{$TOTAL_MENU_ATM}}
        @endif
        
      </h4>
     </div>
    </div>
  </div>
</div>

<div class="row">

  @if (Auth::user()->role=="admin")
  @foreach ($MENU_ADMIN as $item)
  <div class="col-lg-3 col-md-3 col-sm-4 col-6">
    <div class="row d-flex justify-center">
      <div class="col-lg-12 col-md-12 col-sm-6 col-12 mb-4">
        <div class="card b-radius card-noborder bg-blue">
          <div class="card-body custom-card-p">
            <div class="row text-center d-flex justify-content-center">
            <div class="text-white text-center">  {{$item->MENU_NAME}}</div>
            </div>
          </div>
        </div>
      </div>
    
    </div>
  </div>
  @endforeach
  @elseif(Auth::user()->role=="spv")
  @foreach ($MENU_ADMIN as $item)
  <div class="col-lg-3 col-md-3 col-sm-4 col-6">
    <div class="row d-flex justify-center">
      <div class="col-lg-12 col-md-12 col-sm-6 col-12 mb-4">
        <div class="card b-radius card-noborder bg-blue">
          <div class="card-body custom-card-p">
            <div class="row text-center d-flex justify-content-center">
            <div class="text-white text-center">  {{$item->MENU_NAME}}</div>
            </div>
          </div>
        </div>
      </div>
    
    </div>
  </div>
  @endforeach
  @elseif(Auth::user()->role=="manager")
  @foreach ($MENU_ADMIN as $item)
  <div class="col-lg-3 col-md-3 col-sm-4 col-6">
    <div class="row d-flex justify-center">
      <div class="col-lg-12 col-md-12 col-sm-6 col-12 mb-4">
        <div class="card b-radius card-noborder bg-blue">
          <div class="card-body custom-card-p">
            <div class="row text-center d-flex justify-content-center">
            <div class="text-white text-center">  {{$item->MENU_NAME}}</div>
            </div>
          </div>
        </div>
      </div>
    
    </div>
  </div>
  @endforeach
  @endif
  


  
  
</div>
@endsection
