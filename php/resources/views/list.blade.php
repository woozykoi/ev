@extends('base')

@section('title')
<title>User List</title>
@endsection

@section('content')
<div id="user-list" data-roles='@json($roles)' data-users='@json($users)'></div>
@endsection
