<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserRole extends Model
{
    use HasFactory;

    /**
     * @var string
     */
    protected $table = 'users_roles';

    // public function user()
    // {
    //     return $this->belongsTo(User::class, 'user_id');
    // }

    // public function role()
    // {
    //     return $this->belongsTo(Role::class, 'role_id');
    // }
}
