# http-tester

A tiny webservice which returns a http error page from specified code in parameters.

[![Build Status](https://travis-ci.org/levups/http-tester.svg?branch=master)](https://travis-ci.org/levups/http-tester) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/0ec9c29ee71d4074a8988ffd47c784cd)](https://www.codacy.com/app/levups/http-tester?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=levups/http-tester&amp;utm_campaign=Badge_Grade)

## Setup

http-tester is a little sinatra application.

To launch server, either `rackup -p 5000` or use provided `Procfile` with `foreman start`.

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
