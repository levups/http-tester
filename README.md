# http-tester

A tiny webservice which returns a http error page from specified code in parameters.

## Setup

http-tester is a little sinatra application. To launch server, either `rackup -p 5000` or use provided `Procfile` with `foreman start`.

## Usage

```bash
$ curl http://localhost:5000/code/200
OK

$ curl http://localhost:5000/code/500
Internal Server Error

$ curl -I http://localhost:5000/code/500
HTTP/1.1 500 Internal Server Error
Content-Type: text/html;charset=utf-8
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Content-Length: 21
```
