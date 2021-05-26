<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class UserMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {

        if(Auth::check() && Auth::user()->is_banned){
            $banned = Auth::user()->is_banned==true;
            Auth::logout();

            if($banned==1){
                $message = 'Your account is banned . please contact the adminstrator';

                return redirect()->route('login')
                ->with('status',$message)
                ->withErrors(['email'=>'Your account is banned . please contact the adminstrator']);
            }

        

        }
        // return $next($request);
    }
}
