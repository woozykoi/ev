@extends('base')

@section('title')
<title>Create User</title>
@endsection

@section('content')
<div id="user-create" data-roles='@json($roles)'></div>
@endsection
