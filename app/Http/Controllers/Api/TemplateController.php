<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Template;
use Illuminate\Http\Request;

class TemplateController extends Controller
{
    public function index()
    {
        $templates = Template::where('is_public', true)->get();
        return response()->json($templates);
    }

    public function show($id)
    {
        $template = Template::find($id);

        if (!$template) {
            return response()->json(['message' => 'Template not found'], 404);
        }

        return response()->json($template);
    }

    public function store(Request $request)
    {
        // Only admin can create templates
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'html_template' => 'required|string',
            'thumbnail_url' => 'nullable|string|max:255',
            'is_public' => 'boolean',
        ]);

        $template = Template::create($validated);

        return response()->json($template, 201);
    }
}
