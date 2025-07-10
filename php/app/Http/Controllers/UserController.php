<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\User;
use Exception;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\View\View;
use Symfony\Component\HttpFoundation\Response;

class UserController extends Controller
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function list(): View
    {
        $roles = Role::orderBy('name')->pluck('name')->toArray();

        $users = User::orderBy('name')->get()->map(function ($user) {
            return [
                'name' => $user->name,
                'email' => $user->email,
                'roles' => $user->roles->pluck('name'),//->implode(', '),
            ];
        })->toArray();

        return view('list', ['roles' => $roles, 'users' => $users]);
    }

    public function new(): View
    {
        $roles = Role::orderBy('name')->pluck('name')->toArray();

        return view('new', ['roles' => $roles]);
    }

    public function create(): JsonResponse
    {
        $request = request();

        $newUser = Validator::make($request->all(), [
            'name' => 'required|string|max:100',
            'roles' => 'required|array',
            'roles.*' => 'exists:user_roles,name',
            'email' => 'required|email|max:100|unique:users,email',
        ])->validate();

        $user = new User([
            'name' => $newUser['name'],
            'password' => '',
            'email' => $newUser['email'],
        ]);

        try {
            $user->save();

            $user->roles()->sync(
                Role::whereIn('name', $newUser['roles'])->pluck('id')->toArray()
            );
        } catch (Exception $e) {
            if ($e instanceof QueryException && $e->getCode() === '23000') {
                return response()->json(
                    [
                        'message' => 'The given data was invalid.',
                        'errors' => [
                            'email' => ['The email has already been taken.'],
                        ],
                    ],
                    Response::HTTP_UNPROCESSABLE_ENTITY,
                );
            }

            return response()->json(['message' => 'An error occurred while creating the user.'], Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        return response()->json(['success' => true]);
    }
}
