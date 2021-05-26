<?php

namespace App\Http\Middleware;

use Closure;
use Session;
use Illuminate\Support\Facades\Auth;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next,...$roles)
    {
        if(Auth::check() && Auth::user()->is_banned){
            $banned = Auth::user()->is_banned==1;
            // Auth::logout();

            if($banned){
                $message= 'Your account has been banned contact the adminstrator';
            }
            return redirect()->route('login')
            ->with('status',$message)
            ->withErrors(['login_failed'=>'Your account has been banned contact the adminstrator']);

    //    Session::flash('is_banned', $message);

            //    return redirect('/login');

            //  return  dd($message);
        }
    
        else if(in_array($request->user()->role,$roles)){
            return $next($request);
        }

        return back();
    }
}