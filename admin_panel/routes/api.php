<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\ReportApiController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Public API endpoints for mobile app
Route::prefix('v1')->group(function () {
    // Categories
    Route::get('/categories', [ReportApiController::class, 'getCategories']);
    
    // User
    Route::post('/user/auth', [ReportApiController::class, 'getOrCreateUser']);
    
    // Reports
    Route::get('/reports/user/{userId}', [ReportApiController::class, 'getUserReports']);
    Route::post('/reports', [ReportApiController::class, 'createReport']);
    Route::get('/reports/{id}', [ReportApiController::class, 'getReportDetail']);
    
    // Statistics
    Route::get('/statistics', [ReportApiController::class, 'getStatistics']);
});
