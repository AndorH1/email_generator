<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\TemplateController;
use App\Http\Controllers\Api\SignatureController;
use App\Http\Controllers\Api\ImageProxyController;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/image-proxy', [ImageProxyController::class, 'proxy']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);

    // Profile
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);

    // Templates
    Route::get('/templates', [TemplateController::class, 'index']);
    Route::get('/templates/{id}', [TemplateController::class, 'show']);
    Route::post('/templates', [TemplateController::class, 'store']);

    // Signatures
    Route::get('/signatures', [SignatureController::class, 'index']);
    Route::post('/signatures', [SignatureController::class, 'store']);
    Route::get('/signatures/{id}', [SignatureController::class, 'show']);
    Route::put('/signatures/{id}', [SignatureController::class, 'update']);
    Route::delete('/signatures/{id}', [SignatureController::class, 'destroy']);
    Route::get('/signatures/{id}/export', [SignatureController::class, 'export']);
});
