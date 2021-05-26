@foreach($users as $user)
<tr>
  <td>
  	<img src="{{ asset('pictures/' . $user->foto) }}">
  	<span class="ml-2">{{ $user->nama }}</span>
  </td>
  <td>{{ $user->email }}</td>
  <td>
    @if($user->is_banned)
    <span class="btn btn-danger">Terblokir</span>
    @else
    <span class="btn btn-primary">Active</span>
    @endif
  </td>
  <td>127.0.0.1</td>
  <td> 
    @if($user->role == 'admin')
    <span class="btn admin-span">{{ $user->role }}</span>
    @elseif($user->role == 'manager')
    <span class="btn btn-info">{{ $user->role }}</span>
    @elseif($user->role == 'asisten manager')
    <span class="btn btn-success">{{ $user->role }}</span>
    @elseif($user->role == 'TMO')
    <span class="btn btn-warning">{{ $user->role }}</span>
    @else
    <span class="btn btn-primary">{{ $user->role }}</span>
    @endif
  </td>
  <td>
  	<button type="button" class="btn btn-icons btn-rounded btn-secondary">
        <i class="mdi mdi-pencil"></i>
    </button>
    <button type="button" class="btn btn-icons btn-rounded btn-secondary ml-1">
        <i class="mdi mdi-close"></i>
    </button>
  </td>
</tr>
@endforeach