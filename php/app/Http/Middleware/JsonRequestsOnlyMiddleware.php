<?php

namespace App\Http\Middleware;

use Closure;
use GuzzleHttp\Psr7\MimeType;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class JsonRequestsOnlyMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Illuminate\Http\Response|\Illuminate\Http\RedirectResponse)  $next
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next)
    {
        $httpContentType = $request->header('Content-Type');
        $jsonMimeType = MimeType::fromExtension('json');

        if (!$httpContentType || $httpContentType !== $jsonMimeType) {
            return response()->json(['message' => 'Unsupported Media Type'], Response::HTTP_UNSUPPORTED_MEDIA_TYPE);
        }

        $httpAccept = $request->header('Accept');
        $pregJsonMimeType = preg_quote($jsonMimeType, '/');

        if (!$httpAccept || !preg_match("/[\^, ]*?({$pregJsonMimeType}|\*\/\*)[\$, ]*?/i", $httpAccept)) {
            return response()->json(['message' => 'Unsupported Media Type'], Response::HTTP_UNSUPPORTED_MEDIA_TYPE);
        }

        return $next($request);
    }
}
