<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\Category;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class ReportApiController extends Controller
{
    // Get all categories
    public function getCategories()
    {
        $categories = Category::all();
        return response()->json([
            'success' => true,
            'data' => $categories
        ]);
    }

    // Get user reports
    public function getUserReports($userId)
    {
        $reports = Report::with('category')
            ->where('user_id', $userId)
            ->latest()
            ->get()
            ->map(function($report) {
                return [
                    'id' => $report->id,
                    'user_id' => $report->user_id,
                    'category_id' => $report->category_id,
                    'category' => $report->category,
                    'title' => $report->title,
                    'description' => $report->description,
                    'location' => $report->location,
                    'media' => $report->media,
                    'status' => $report->status,
                    'is_verified' => $report->is_verified,
                    'verified_at' => $report->verified_at,
                    'verified_by' => $report->verified_by,
                    'rejection_reason' => $report->rejection_reason,
                    'admin_response' => $report->admin_response,
                    'responded_at' => $report->responded_at,
                    'created_at' => $report->created_at,
                    'updated_at' => $report->updated_at,
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $reports
        ]);
    }

    // Create new report
    public function createReport(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'nullable|string',
            'media' => 'nullable|array',
            'media.*' => 'file|mimes:jpg,jpeg,png,mp4,mov|max:10240' // Max 10MB
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $mediaFiles = [];
        if ($request->hasFile('media')) {
            foreach ($request->file('media') as $file) {
                $path = $file->store('reports', 'public');
                $mediaFiles[] = 'storage/' . $path;
            }
        }

        $report = Report::create([
            'user_id' => $request->user_id,
            'category_id' => $request->category_id,
            'title' => $request->title,
            'description' => $request->description,
            'location' => $request->location,
            'media' => $mediaFiles,
            'status' => 'Diproses'
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Report created successfully',
            'data' => $report->load('category')
        ], 201);
    }

    // Get report detail
    public function getReportDetail($id)
    {
        $report = Report::with(['category', 'user'])->find($id);

        if (!$report) {
            return response()->json([
                'success' => false,
                'message' => 'Report not found'
            ], 404);
        }

        $data = [
            'id' => $report->id,
            'user_id' => $report->user_id,
            'user' => $report->user,
            'category_id' => $report->category_id,
            'category' => $report->category,
            'title' => $report->title,
            'description' => $report->description,
            'location' => $report->location,
            'media' => $report->media,
            'status' => $report->status,
            'is_verified' => $report->is_verified,
            'verified_at' => $report->verified_at,
            'verified_by' => $report->verified_by,
            'rejection_reason' => $report->rejection_reason,
            'admin_response' => $report->admin_response,
            'responded_at' => $report->responded_at,
            'created_at' => $report->created_at,
            'updated_at' => $report->updated_at,
        ];

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    // Get or create user
    public function getOrCreateUser(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'name' => 'required|string',
            'google_id' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::firstOrCreate(
            ['email' => $request->email],
            [
                'name' => $request->name,
                'password' => bcrypt(uniqid()), // Random password for Google users
            ]
        );

        return response()->json([
            'success' => true,
            'data' => $user
        ]);
    }

    // Get statistics
    public function getStatistics()
    {
        $totalReports = Report::count();
        $reportsByStatus = Report::selectRaw('status, count(*) as total')
            ->groupBy('status')
            ->get();
        $reportsByCategory = Report::with('category')
            ->selectRaw('category_id, count(*) as total')
            ->groupBy('category_id')
            ->get();

        return response()->json([
            'success' => true,
            'data' => [
                'total_reports' => $totalReports,
                'by_status' => $reportsByStatus,
                'by_category' => $reportsByCategory
            ]
        ]);
    }
}
