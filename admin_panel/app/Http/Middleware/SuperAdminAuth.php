<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SuperAdminAuth
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (!session()->has('admin_id')) {
            return redirect()->route('login')->with('error', 'Silakan login terlebih dahulu!');
        }

        $admin = \App\Models\Admin::find(session('admin_id'));

        if (!$admin || !$admin->is_active) {
            session()->flush();
            return redirect()->route('login')->with('error', 'Akun tidak aktif!');
        }

        // Check if user is super admin
        if ($admin->role !== 'super_admin') {
            abort(403, 'Akses ditolak! Hanya Super Admin yang dapat mengakses fitur ini.');
        }

        return $next($request);
    }
}
