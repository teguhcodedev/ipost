@extends('templates/main')
@section('css')
<link rel="stylesheet" href="{{ asset('css/manage_account/new_account/style.css') }}">
@endsection
@section('content')
<div class="row page-title-header ">
  <div class="col-12">
    <div class="page-header d-flex justify-content-start align-items-center">
      <div class="quick-link-wrapper d-md-flex flex-md-wrap">
        <ul class="quick-links">
          <li><a href="{{ url('account') }}">Register Account</a></li>
          <li><a href="{{ url('account/edit/'.$MUA->id) }}">Update Account</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="row mb-5">
	<div class="col-12">
		<div class="card card-noborder b-radius shadow">
			<div class="card-body">
				<form action="{{ url('account/update/'.$MUA->id) }}" method="post" name="create_form" enctype="multipart/form-data">
				  @csrf
				  <div class="form-group row">
					
				    <label class="col-12 font-weight-bold col-form-label">Photo Profil</label>
				    <div class="col-6 d-flex flex-row align-items-center mt-2 mb-2">
				    	<img src="{{ asset('chubb_foto/'.$MUA->AGENT_PHOTO) }}" class="default-img mr-4" id="preview-foto">
				    	<div class="btn-action">
				    		<input type="file" name="foto" id="foto" hidden="">
				    		<button class="btn btn-sm upload-btn mr-1" type="button">Upload Photo</button>
				    		<button class="btn btn-sm delete-btn" type="button">Delete</button>
				    	</div>
				    </div>
					<div class="col-2">
					</div>
					<div class="col-4 align-items-center  mt-2 mb-2 float-right">
						<div class="mb-3" style="margin-top:-20px">
							<select class="form-control" name="team">
								<option value="">-- Choose Team --</option>
								<option value="TEAM 1" selected>TEAM 1</option>
							</select>
							<div class="col-12 error-notice" id="team_error"></div>
						</div>
						
						<br/>
						<div>
							<input type="password" id="myInput" value="" name="password" class="form-control" VALUE="12345678" style="width:57%" disabled>
							<button type="button" id="myButton" class="btn btn-sm btn-primary">Genarate Password</button>
							<div class="col-12 error-notice" id="password_error"></div>
						</div>
					</div>
					
				  </div>


				  <div class="form-group">
					<div class="row">
						<div class="col-6">
							<label class="col-12 font-weight-bold col-form-label">Username<span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="text" class="form-control" name="username" value="{{$MUA->AGENT_USERNAME}}" placeholder="Enter Username">
							</div>
							<div class="col-6 error-notice" id="username_error"></div>
						</div>
						<div class="col-6">
							<label class="col-6 font-weight-bold col-form-label">Fullname<span class="text-danger"></span></label>
							<div class="col-12">
								<input type="text" class="form-control" name="fullname"  value="{{$MUA->AGENT_NAME}}" placeholder="Enter Fullname">
							</div>
							<div class="col-6 error-notice" id="fullname_error"></div>
						</div>
					</div>
				  </div>
			

				  
				  <div class="form-group">
					<div class="row mt-4">
						<div class="col-6">
						
							<label class="col-12 font-weight-bold col-form-label">User Level <span class="text-danger">*</span></label>
							<div class="col-12">
								<select name="position" class="form-control">
									<option value="">--- Select Position {{$MUA->AGENT_LEVEL}} ---</option>
                                    @if ($MUA->AGENT_LEVEL=='TELEMARKETER')
                                       <option value="TELEMARKETER" selected>TELEMARKETER</option>
                                       <option value="SPV">SUPERVISOR</option>
                                       <option value="MANAGER">ASSOCIATE TELEMARKETING MANAGER</option>
                                       <option value="QUALITY ASSURANCE">QUALITY ASSURANCE</option>
                                       <option value="STRATEGIC SALES SPECIALIST">STRATEGIC SALES SPECIALIST</option>
                                       <option value="ADMIN">ADMIN</option>
                                    @elseif ($MUA->AGENT_LEVEL=='SPV')
                                      <option value="TELEMARKETER">TELEMARKETER</option>
                                      <option value="SPV" selected>SUPERVISOR</option>
                                      <option value="MANAGER">ASSOCIATE TELEMARKETING MANAGER</option>
                                      <option value="QUALITY ASSURANCE">QUALITY ASSURANCE</option>
                                      <option value="STRATEGIC SALES SPECIALIST">STRATEGIC SALES SPECIALIST</option>
                                      <option value="ADMIN">ADMIN</option>
                                    @elseif ($MUA->AGENT_LEVEL=='MANAGER')
                                       <option value="TELEMARKETER">TELEMARKETER</option>
                                       <option value="SPV">SUPERVISOR</option>
                                       <option value="MANAGER" selected>ASSOCIATE TELEMARKETING MANAGER</option>
                                       <option value="QUALITY ASSURANCE">QUALITY ASSURANCE</option>
                                       <option value="STRATEGIC SALES SPECIALIST">STRATEGIC SALES SPECIALIST</option>
                                       <option value="ADMIN">ADMIN</option>
                                    @elseif ($MUA->AGENT_LEVEL=='QUALITY ASSURANCE')
                                      <option value="TELEMARKETER">TELEMARKETER</option>
                                      <option value="SPV">SUPERVISOR</option>
                                      <option value="MANAGER">ASSOCIATE TELEMARKETING MANAGER</option>
                                      <option value="QUALITY ASSURANCE" selected>QUALITY ASSURANCE</option>
                                      <option value="STRATEGIC SALES SPECIALIST">STRATEGIC SALES SPECIALIST</option>
                                      <option value="ADMIN">ADMIN</option>
                                    @elseif ($MUA->AGENT_LEVEL=='STRATEGIC SALES SPECIALIST')
                                     <option value="TELEMARKETER">TELEMARKETER</option>
                                      <option value="SPV">SUPERVISOR</option>
                                      <option value="MANAGER">ASSOCIATE TELEMARKETING MANAGER</option>
                                      <option value="QUALITY ASSURANCE">QUALITY ASSURANCE</option>
                                       <option value="STRATEGIC SALES SPECIALIST" selected>STRATEGIC SALES SPECIALIST</option>
                                       <option value="ADMIN">ADMIN</option>
                                    @elseif ($MUA->AGENT_LEVEL=='ADMIN')
                                        <option value="TELEMARKETER">TELEMARKETER</option>
                                        <option value="SPV">SUPERVISOR</option>
                                        <option value="MANAGER">ASSOCIATE TELEMARKETING MANAGER</option>
                                        <option value="QUALITY ASSURANCE">QUALITY ASSURANCE</option>
                                        <option value="STRATEGIC SALES SPECIALIST">STRATEGIC SALES SPECIALIST</option>
                                         <option value="ADMIN" selected>ADMIN</option>
                                    @endif
								</select>
								<div class="col-12 error-notice" id="position_error"></div>
						   </div>
				    	</div>
			  
						<div class="col-6">
							<label class="col-6 font-weight-bold col-form-label">DN Number<span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="text" class="form-control" name="dn"
                                value="{{$MUA->AGENT_DN}}"
                                placeholder="Enter Dialnumber : 081218289">
							</div>
							<div class="col-6 error-notice" id="dn_error"></div>
						</div>
					</div>
				  </div>
				
				
				  <div class="form-group ">
					  <div class="row mt-4">
						  <div class="col-6">
							<label class="col-12 font-weight-bold col-form-label">Supervisor<span class="text-danger">*</span></label>
							<div class="col-12">
								{{-- <select class="form-control" name="supervisor">
									<option value="">-- Supervisor --</option>
									<option value="SPV">SPV</option>
								  <option value="SPV 02">SPV 02</option>
							
								</select> --}}

                               

								<select name="supervisor" class="form-control" style="width:250px">
									<option value="">--- Select SPV ---</option>
                                 @foreach ($spv??'' as $item)
                                    <option value="{{ $item->AGENT_USERNAME }}" {{ ( $item->AGENT_USERNAME == $MUA->SPV_ID) ? 'selected' : '' }}> {{            $item->AGENT_USERNAME}}
                                     </option>
                                  @endforeach    
       
								</select>
                            
								<div class="col-12 error-notice" id="supervisor_error"></div>
						  </div>
						</div>
						  <div class="col-6">
							<label class="col-12 font-weight-bold col-form-label">Manager</label>
							<div class="col-12">
								<select name="manager" class="form-control">
									<option value="">--- Select MANAGER ---</option>
									@foreach ($manager ??'' as  $value)
                                    <option value="{{ $value->AGENT_USERNAME }}" {{ ( $value->AGENT_USERNAME == $MUA->MANAGER_ID) ? 'selected' : '' }}> {{            $value->AGENT_USERNAME}}
                                    </option>
									@endforeach
								</select>
								<div class="col-12 error-notice" id="manager_error"></div>
						  </div>
					  </div>
				
					</div>		
				</div>
			
				<div class="form-group">
					<div class="row mt-4">
						<div class="col-6">
							<label class="col-12 font-weight-bold col-form-label">Can use soft phone</label>
							<div class="col-12">
								<input type="radio" value="1" name="softphone" class="form_radio" id="yes"
                                @if ($MUA->CAN_USE_SOFTPHONE==1)
                                    checked
                               @endif
                                >
								<label for ="yes" class="form_label" >Yes</label>
						
								<input type="radio"  value="0" name="softphone" 
                                @if ($MUA->CAN_USE_SOFTPHONE==0)
                                checked
                                @endif
                                class="form_radio" id="no"
                                
                                >
								<label for ="no" class="form_label">No</label>
							</div>
							<div class="col-12 error-notice" id="softphone_error"></div>
						</div>
						<div class="col-6">
							<label class="col-12 font-weight-bold col-form-label">Dial type</label>
							<div class="col-12">
							
									<input type="radio" value="preview" name="dialtype" class="form_radio" id="preview"
                                    @if ($MUA->STS_AUDITORIAL=="preview")
                                    checked
                               @endif
                                    >
                           
									<label for ="preview" class="form_label" >Preview</label>
							
									<input type="radio"  value="progressive" name="dialtype" class="form_radio"
                                    @if ($MUA->STS_AUDITORIAL=="progressive")
                                         checked
                                    @endif
                                    id="progressive">
									<label for ="progressive" class="form_label">Progressive</label>
								</div>
								<div class="col-12 error-notice" id="dialtype_error"></div>
					</div>
						
				</div>

				<div class="form-group">
					<div class="row mt-4">
						<div class="col-6">
						
							<label class="col-12 font-weight-bold col-form-label">Status <span class="text-danger">*</span></label>
							<div class="col-12">
								<select name="STATUS_USER" class="form-control">
									<option value="">--- Select Position---</option>
                                 
                                    @if ($MUA->AGENT_STATUS=="ACTIVE")
                                        <option value="ACTIVE" selected>ACTIVE</option>
                                        <option value="RESIGN">RESIGN</option>  
								    	<option value="TERMINATED">TERMINATED</option> 
                                    @elseif ($MUA->AGENT_STATUS=="RESIGN")
                                        <option value="ACTIVE" >ACTIVE</option>
                                        <option value="RESIGN" selected>RESIGN</option>  
								    	<option value="TERMINATED">TERMINATED</option>   
                                    @elseif ($MUA->AGENT_STATUS=="TERMINATED")
                                        <option value="ACTIVE">ACTIVE</option>
                                        <option value="RESIGN">RESIGN</option>  
								    	<option value="TERMINATED" selected>TERMINATED</option>  
                                    @endif
                                    
									
								</select>
								<div class="col-12 error-notice" id="STATUS_USER_error"></div>
						   </div>
				    	</div>
			  
						<div class="col-6">
							<label class="col-6 font-weight-bold col-form-label">Resign/ Terminated Date<span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="date" class="form-control" name="date_resign" value="{{$MUA->DATE_RESIGN  }}" disabled>
							</div>
							<div class="col-6 error-notice" id="email_error"></div>
						</div>
					</div>
				  </div>

				  <div class="form-group">
					  <div class="row mt-4">
						  <div class="col md-6">
							<label class="col-12 font-weight-bold col-form-label">Join Date<span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="date" class="form-control" name="JOIN_DATE" placeholder="Join Date " value="{{$MUA->DATE_JOIN}}" >
							</div>
							<div class="col-12 error-notice" id="JOIN_DATE_error"></div>
						  </div>
						  <div class="col md-6">
							<label class="col-12 font-weight-bold col-form-label">Target Level <span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="text" name="TARGET_LEVEL" class="form-control"  placeholder="Target Level " disabled>
							</div>
						
							<div class="col-12 error-notice" id="targetlevel_error"></div>
						</div>
					  </div>
					
			      </div>
			
				  <div class="form-group">
					  <div class="row mt-4">
						  <div class="col md-6">
							<label class="col-12 font-weight-bold col-form-label">Sponsor <span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="text" class="form-control" name="sponsor"  placeholder="Sponser " disabled>
							</div>
						
							<div class="col-12 error-notice"></div>
						  </div>
						  <div class="col md-6">
							<label class="col-12 font-weight-bold col-form-label">Product <span class="text-danger">*</span></label>
							<div class="col-12">
								<input type="text" name="PRODUCT" class="form-control"  placeholder="product.... " disabled>
							</div>
						
							<div class="col-12 error-notice"></div>
						  </div>
					  </div>	
			      </div>
	
				  <div class="row mt-5">
				  	<div class="col-12 d-flex justify-content-end">
				  		<button class="btn simpan-btn btn-sm" type="submit"><i class="mdi mdi-content-save"></i> Save</button>
				  	</div>
				  </div>
				</form>
			</div>
		</div>
	</div>
</div>
@endsection
@section('script')

<script src="{{ asset('js/manage_account/new_account/script.js') }}"></script>
<script type="text/javascript">
	@if ($message = Session::get('both_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('team_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('username_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('password_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('fullname_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('position_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif


	@if ($message = Session::get('dn_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('softphone_error'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('JOIN_DATE'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif

	@if ($message = Session::get('STATUS_USER'))
	  swal(
		"",
		"{{ $message }}",
		"error"
	  );
	@endif




	$(document).on('click', '.delete-btn', function(){
		$("#preview-foto").attr("src", "{{ asset('pictures') }}/default.jpg");
	});
</script>

<script src="{{ asset('js/input/script.js') }}"></script>
@endsection