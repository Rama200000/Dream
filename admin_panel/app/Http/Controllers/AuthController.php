<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function showLogin()
    {
        // Redirect if already logged in
        if (session()->has('admin_id')) {
            return redirect()->route('dashboard');
        }
        
        return view('auth.login');
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);

        $admin = Admin::where('email', $request->email)->first();

        if (!$admin) {
            return back()->with('error', 'Email tidak ditemukan!')->withInput();
        }

        if (!$admin->is_active) {
            return back()->with('error', 'Akun Anda tidak aktif! Hubungi administrator.')->withInput();
        }

        if (!Hash::check($request->password, $admin->password)) {
            return back()->with('error', 'Password salah!')->withInput();
        }

        // Update last login
        $admin->update(['last_login' => now()]);

        // Set session
        session([
            'admin_id' => $admin->id,
            'admin_name' => $admin->name,
            'admin_email' => $admin->email,
            'admin_role' => $admin->role,
        ]);

        return redirect()->route('dashboard')->with('success', 'Selamat datang, ' . $admin->name . '!');
    }

    public function logout(Request $request)
    {
        // Clear session
        $request->session()->flush();
        $request->session()->regenerate();

        return redirect()->route('login')->with('success', 'Anda telah logout!');
    }
}
