<?php

use Illuminate\Support\Facades\Route;

// Serve frontend files
Route::get('/', function () {
    return response()->file(public_path('index.html'));
});

Route::get('/login', function () {
    return response()->file(public_path('login.html'));
});

Route::get('/register', function () {
    return response()->file(public_path('register.html'));
});

Route::get('/dashboard', function () {
    return response()->file(public_path('dashboard.html'));
});

Route::get('/editor', function () {
    return response()->file(public_path('editor.html'));
});

Route::get('/profile', function () {
    return response()->file(public_path('profile.html'));
});
