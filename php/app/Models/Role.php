<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    use HasFactory;

    /**
     * @var string
     */
    protected $table = 'user_roles';

    public function users()
    {
        return $this->belongsToMany(UserRole::class, 'users_roles', 'role_id', 'user_id');
    }
}
