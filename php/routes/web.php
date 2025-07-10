<?php

use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return redirect()->route('users.list');
})
    ->name('home');

Route::get('/list', [UserController::class, 'list'])
    ->name('users.list');

Route::get('/new', [UserController::class, 'new'])
    ->name('users.new');

Route::post('/new', [UserController::class, 'create'])
    ->middleware('json.requests.only')
    ->name('users.create');
