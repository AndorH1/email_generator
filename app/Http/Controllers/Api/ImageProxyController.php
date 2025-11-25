<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ImageProxyController extends Controller
{
    public function proxy(Request $request)
    {
        $url = $request->query('url');

        if (!$url || !filter_var($url, FILTER_VALIDATE_URL)) {
            return response()->json(['error' => 'Invalid URL'], 400);
        }

        try {
            // Fetch the image from the external URL
            $response = Http::timeout(10)
                ->withHeaders([
                    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                    'Referer' => 'https://imgur.com/',
                ])
                ->get($url);

            if ($response->successful()) {
                return response($response->body())
                    ->header('Content-Type', $response->header('Content-Type'))
                    ->header('Cache-Control', 'public, max-age=86400')
                    ->header('Access-Control-Allow-Origin', '*');
            }

            return response()->json(['error' => 'Failed to fetch image'], $response->status());
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch image: ' . $e->getMessage()], 500);
        }
    }
}
