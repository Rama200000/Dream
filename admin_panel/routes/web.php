<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\HelpController;
use App\Http\Controllers\AuthController;

// Auth routes (no middleware)
Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->name('login.post');

// Protected routes (require admin auth)
Route::middleware(['admin.auth'])->group(function () {
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');

    // Reports routes
    Route::prefix('reports')->name('reports.')->group(function () {
        Route::get('/', [ReportController::class, 'index'])->name('index');
        Route::get('/{id}', [ReportController::class, 'show'])->name('show');
        
        // Verify dan Reject: Semua admin bisa akses
        Route::post('/{id}/update-status', [ReportController::class, 'updateStatus'])->name('update-status');
        Route::post('/{id}/verify', [ReportController::class, 'verify'])->name('verify');
        Route::post('/{id}/reject', [ReportController::class, 'reject'])->name('reject');
        
        // Delete: Hanya Super Admin
        Route::delete('/{id}', [ReportController::class, 'destroy'])->name('destroy')->middleware('super.admin');
    });

    // Categories routes
    Route::prefix('categories')->name('categories.')->group(function () {
        Route::get('/', [CategoryController::class, 'index'])->name('index');
        
        // Create, Update, Delete: Hanya Super Admin
        Route::middleware('super.admin')->group(function () {
            Route::get('/create', [CategoryController::class, 'create'])->name('create');
            Route::post('/', [CategoryController::class, 'store'])->name('store');
            Route::get('/{id}/edit', [CategoryController::class, 'edit'])->name('edit');
            Route::put('/{id}', [CategoryController::class, 'update'])->name('update');
            Route::delete('/{id}', [CategoryController::class, 'destroy'])->name('destroy');
        });
    });

    // Profile routes
    Route::prefix('profile')->name('profile.')->group(function () {
        Route::get('/', [ProfileController::class, 'index'])->name('index');
        Route::get('/edit', [ProfileController::class, 'edit'])->name('edit');
        Route::put('/update', [ProfileController::class, 'update'])->name('update');
        Route::get('/change-password', [ProfileController::class, 'changePassword'])->name('change-password');
        Route::put('/update-password', [ProfileController::class, 'updatePassword'])->name('update-password');
    });

    // Users routes (Hanya Super Admin)
    Route::prefix('users')->name('users.')->middleware('super.admin')->group(function () {
        Route::get('/', [UserController::class, 'index'])->name('index');
        Route::get('/{id}', [UserController::class, 'show'])->name('show');
        Route::delete('/{id}', [UserController::class, 'destroy'])->name('destroy');
        Route::post('/{id}/block', [UserController::class, 'block'])->name('block');
        Route::post('/{id}/unblock', [UserController::class, 'unblock'])->name('unblock');
    });

    // Settings routes (Hanya Super Admin)
    Route::prefix('settings')->name('settings.')->middleware('super.admin')->group(function () {
        Route::get('/', [SettingsController::class, 'index'])->name('index');
        Route::post('/clear-cache', [SettingsController::class, 'clearCache'])->name('clear-cache');
        Route::post('/maintenance', [SettingsController::class, 'maintenance'])->name('maintenance');
        Route::get('/database', [SettingsController::class, 'database'])->name('database');
        Route::post('/optimize', [SettingsController::class, 'optimize'])->name('optimize');
    });

    // Help routes
    Route::prefix('help')->name('help.')->group(function () {
        Route::get('/', [HelpController::class, 'index'])->name('index');
        Route::get('/documentation', [HelpController::class, 'documentation'])->name('documentation');
        Route::get('/contact', [HelpController::class, 'contact'])->name('contact');
        Route::post('/submit-ticket', [HelpController::class, 'submitTicket'])->name('submit-ticket');
    });

    // Logout route
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
});
