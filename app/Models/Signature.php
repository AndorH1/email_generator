<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Signature extends Model
{
    protected $fillable = [
        'user_id',
        'template_id',
        'data',
        'html_rendered',
    ];

    protected function casts(): array
    {
        return [
            'data' => 'array',
        ];
    }

    /**
     * Get the user that owns the signature.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the template that the signature uses.
     */
    public function template()
    {
        return $this->belongsTo(Template::class);
    }
}
