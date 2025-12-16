<?php

namespace App\Http\Controllers;

use App\Models\Report;
use App\Models\Category;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $query = Report::with(['user', 'category']);

        // Filter berdasarkan status
        if ($request->has('status') && $request->status != '') {
            $query->where('status', $request->status);
        }

        // Filter berdasarkan kategori
        if ($request->has('category_id') && $request->category_id != '') {
            $query->where('category_id', $request->category_id);
        }

        // Search
        if ($request->has('search') && $request->search != '') {
            $query->where(function($q) use ($request) {
                $q->where('title', 'like', '%' . $request->search . '%')
                  ->orWhere('description', 'like', '%' . $request->search . '%');
            });
        }

        $reports = $query->latest()->paginate(15);
        $categories = Category::all();

        return view('reports.index', compact('reports', 'categories'));
    }

    public function show($id)
    {
        $report = Report::with(['user', 'category'])->findOrFail($id);
        return view('reports.show', compact('report'));
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:Diproses,Ditindaklanjuti,Selesai',
            'admin_response' => 'nullable|string'
        ]);

        $report = Report::findOrFail($id);
        $report->update([
            'status' => $request->status,
            'admin_response' => $request->admin_response,
            'responded_at' => now()
        ]);

        return redirect()->back()->with('success', 'Status laporan berhasil diperbarui');
    }

    public function verify(Request $request, $id)
    {
        $report = Report::findOrFail($id);
        
        $report->update([
            'is_verified' => true,
            'verified_at' => now(),
            'verified_by' => 'Admin', // Bisa diganti dengan auth user name
            'rejection_reason' => null
        ]);

        return redirect()->back()->with('success', 'Laporan berhasil diverifikasi');
    }

    public function reject(Request $request, $id)
    {
        $request->validate([
            'rejection_reason' => 'required|string'
        ]);

        $report = Report::findOrFail($id);
        
        $report->update([
            'is_verified' => false,
            'verified_at' => now(),
            'verified_by' => 'Admin',
            'rejection_reason' => $request->rejection_reason,
            'status' => 'Ditolak'
        ]);

        return redirect()->back()->with('success', 'Laporan ditolak dengan alasan: ' . $request->rejection_reason);
    }

    public function destroy($id)
    {
        $report = Report::findOrFail($id);
        
        // Hapus media files jika ada
        if ($report->media) {
            foreach ($report->media as $mediaPath) {
                if (file_exists(public_path($mediaPath))) {
                    unlink(public_path($mediaPath));
                }
            }
        }
        
        $report->delete();

        return redirect()->route('reports.index')->with('success', 'Laporan berhasil dihapus');
    }
}
