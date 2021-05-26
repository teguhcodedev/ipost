@extends('templates/main')
@section('css')
<link rel="stylesheet" href="{{ asset('css/profile/style.css') }}">
@endsection
@section('content')
<h1>Activity Monitroing</h1>
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
