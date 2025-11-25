<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        $user = $request->user();
        $profile = $user->profile;

        if (!$profile) {
            return response()->json(['message' => 'Profile not found'], 404);
        }

        return response()->json([
            'id' => $profile->id,
            'user_id' => $profile->user_id,
            'job_title' => $profile->job_title,
            'phone' => $profile->phone,
            'website' => $profile->website,
            'avatar_url' => $profile->avatar_url,
            'full_name' => $user->full_name,
            'email' => $user->email,
        ]);
    }

    public function update(Request $request)
    {
        $user = $request->user();
        $profile = $user->profile;

        if (!$profile) {
            return response()->json(['message' => 'Profile not found'], 404);
        }

        $validated = $request->validate([
            'job_title' => 'nullable|string|max:100',
            'phone' => 'nullable|string|max:50',
            'website' => 'nullable|string|max:255',
            'avatar_url' => 'nullable|string|max:255',
        ]);

        $profile->update($validated);

        return response()->json($profile);
    }
}
