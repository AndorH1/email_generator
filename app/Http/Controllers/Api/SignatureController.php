<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Signature;
use App\Models\Template;
use Illuminate\Http\Request;

class SignatureController extends Controller
{
    private function renderTemplate(string $template, array $data): string
    {
        $rendered = $template;
        foreach ($data as $key => $value) {
            $placeholder = '{{' . $key . '}}';
            $rendered = str_replace($placeholder, (string) $value, $rendered);
        }
        return $rendered;
    }

    public function index(Request $request)
    {
        $signatures = $request->user()->signatures;
        return response()->json($signatures);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'template_id' => 'required|exists:templates,id',
            'data' => 'required|array',
        ]);

        $template = Template::find($validated['template_id']);

        if (!$template) {
            return response()->json(['message' => 'Template not found'], 404);
        }

        $htmlRendered = $this->renderTemplate($template->html_template, $validated['data']);

        $signature = Signature::create([
            'user_id' => $request->user()->id,
            'template_id' => $validated['template_id'],
            'data' => $validated['data'],
            'html_rendered' => $htmlRendered,
        ]);

        return response()->json($signature, 201);
    }

    public function show(Request $request, $id)
    {
        $signature = Signature::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$signature) {
            return response()->json(['message' => 'Signature not found'], 404);
        }

        return response()->json($signature);
    }

    public function update(Request $request, $id)
    {
        $signature = Signature::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$signature) {
            return response()->json(['message' => 'Signature not found'], 404);
        }

        $validated = $request->validate([
            'template_id' => 'required|exists:templates,id',
            'data' => 'required|array',
        ]);

        $template = Template::find($validated['template_id']);

        if (!$template) {
            return response()->json(['message' => 'Template not found'], 404);
        }

        $htmlRendered = $this->renderTemplate($template->html_template, $validated['data']);

        $signature->update([
            'template_id' => $validated['template_id'],
            'data' => $validated['data'],
            'html_rendered' => $htmlRendered,
        ]);

        return response()->json($signature);
    }

    public function destroy(Request $request, $id)
    {
        $signature = Signature::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$signature) {
            return response()->json(['message' => 'Signature not found'], 404);
        }

        $signature->delete();

        return response()->json(null, 204);
    }

    public function export(Request $request, $id)
    {
        $signature = Signature::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if (!$signature) {
            return response()->json(['message' => 'Signature not found'], 404);
        }

        return response($signature->html_rendered, 200)
            ->header('Content-Type', 'text/html');
    }
}
