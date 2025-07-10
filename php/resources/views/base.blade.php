<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        @yield('title')

        <link rel="stylesheet" type="text/css" href="{{ mix('/css/app.css') }}">
        <link href="{{ asset('css/app.css') }}" rel="stylesheet" type="text/css">

        <style type="text/css">
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
            }

            nav {
                background: #222;
                margin-bottom: 24px;
                padding: 12px 0 12px 24px;
                width: 100%;
            }

            nav a {
                color: #fff;
                font-weight: 500;
                margin-right: 24px;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <nav>
            <a href="/list">List</a>
            <a href="/new">New</a>
        </nav>

        @yield('content')

        <script src="{{ mix('/js/app.js') }}"></script>
    </body>
</html>
