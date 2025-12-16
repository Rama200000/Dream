<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminAuth
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, $role = null): Response
    {
        if (!session()->has('admin_id')) {
            return redirect()->route('login')->with('error', 'Silakan login terlebih dahulu!');
        }

        $admin = \App\Models\Admin::find(session('admin_id'));

        if (!$admin || !$admin->is_active) {
            session()->flush();
            return redirect()->route('login')->with('error', 'Akun tidak aktif!');
        }

        // Check role if specified
        if ($role && $admin->role !== $role) {
            abort(403, 'Unauthorized action.');
        }

        return $next($request);
    }
}
