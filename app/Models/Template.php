<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Template extends Model
{
    protected $fillable = [
        'name',
        'html_template',
        'thumbnail_url',
        'is_public',
    ];

    protected function casts(): array
    {
        return [
            'is_public' => 'boolean',
        ];
    }

    /**
     * Get the signatures for the template.
     */
    public function signatures()
    {
        return $this->hasMany(Signature::class);
    }
}
