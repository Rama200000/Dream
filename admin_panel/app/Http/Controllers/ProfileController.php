<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    public function index()
    {
        $admin = \App\Models\Admin::find(session('admin_id'));
        return view('profile.index', compact('admin'));
    }

    public function edit()
    {
        $admin = \App\Models\Admin::find(session('admin_id'));
        return view('profile.edit', compact('admin'));
    }

    public function update(Request $request)
    {
        $admin = \App\Models\Admin::find(session('admin_id'));

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:admins,email,' . $admin->id,
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:500',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        $data = $request->only(['name', 'email', 'phone', 'address']);

        // Handle avatar upload
        if ($request->hasFile('avatar')) {
            $avatarPath = $request->file('avatar')->store('avatars', 'public');
            $data['avatar'] = $avatarPath;

            // Delete old avatar
            if ($admin->avatar && Storage::disk('public')->exists($admin->avatar)) {
                Storage::disk('public')->delete($admin->avatar);
            }
        }

        $admin->update($data);

        // Update session data
        session([
            'admin_name' => $admin->name,
            'admin_email' => $admin->email,
        ]);

        return redirect()->route('profile.index')->with('success', 'Profile berhasil diperbarui!');
    }

    public function changePassword()
    {
        $admin = \App\Models\Admin::find(session('admin_id'));
        return view('profile.change-password', compact('admin'));
    }

    public function updatePassword(Request $request)
    {
        $admin = \App\Models\Admin::find(session('admin_id'));

        $request->validate([
            'current_password' => 'required|string|min:6',
            'new_password' => 'required|string|min:6|confirmed',
        ], [
            'current_password.required' => 'Password saat ini harus diisi',
            'new_password.required' => 'Password baru harus diisi',
            'new_password.min' => 'Password baru minimal 6 karakter',
            'new_password.confirmed' => 'Konfirmasi password tidak cocok',
        ]);

        // Validate current password
        if (!Hash::check($request->current_password, $admin->password)) {
            return back()->with('error', 'Password saat ini salah!');
        }

        // Update password
        $admin->update([
            'password' => Hash::make($request->new_password)
        ]);

        return redirect()->route('profile.index')->with('success', 'Password berhasil diubah!');
    }
}
