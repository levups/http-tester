# frozen_string_literal: true

require "bundler"
require "bundler/setup"
require "sinatra"
require "json"

SAMPLE_TEXT = <<~HEREDOC
  Stand up for what you believe in, even if it means standing alone.
  - Andy Biersack
HEREDOC

SAMPLE_XML = <<~HEREDOC
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <message>
    <from>Alice</from>
    <to>Bob</to>
    <body>Hello</body>
  </message>
HEREDOC

SAMPLE_HTML = <<~HEREDOC
  <!doctype html>
  <html lang="en">
  <head><meta charset="utf-8" /><title>Hi</title></head>
  <body><p>Hello World !</p></body>
  </html>
HEREDOC

SAMPLE_JS = <<~HEREDOC
  function changeTitle() { document.querySelector("title").innerText = "Plop" };
  setTimeout(changeTitle, 2000);
HEREDOC

SAMPLE_HTML_JS_AD = <<~HEREDOC
  <!doctype html>
  <html lang="en">
  <head><meta charset="utf-8" /><title>Hi</title></head>
  <script language="javascript" src="/s_code.js"></script>
  <body><p>Hello World !</p></body>
  </html>
HEREDOC

SAMPLE_JSON = {"life" => 42, "foo" => "bar", "false" => true, "pi" => 13.37}.to_json

KNOWN_HTTP_CODES = {
  200 => "OK",
  201 => "Created",
  202 => "Accepted",
  203 => "Non-Authoritative Information",
  204 => "No Content",
  205 => "Reset Content",
  206 => "Partial Content",
  207 => "Multi-Status",
  210 => "Content Different",
  226 => "IM Used",
  300 => "Multiple Choices",
  301 => "Moved Permanently",
  302 => "Moved Temporarily",
  303 => "See Other",
  304 => "Not Modified",
  305 => "Use Proxy",
  307 => "Temporary Redirect",
  308 => "Permanent Redirect",
  310 => "Too many Redirects",
  400 => "Bad Request",
  401 => "Unauthorized",
  402 => "Payment Required",
  403 => "Forbidden",
  404 => "Not Found",
  405 => "Method Not Allowed",
  406 => "Not Acceptable",
  407 => "Proxy Authenticat,ion Required",
  408 => "Request Time-out",
  409 => "Conflict",
  410 => "Gone",
  411 => "Length Required",
  412 => "Precondition Failed",
  413 => "Request Entity Too Large",
  414 => "Request-URI Too Long",
  415 => "Unsupported Media Type",
  416 => "Requested range unsatisfiable",
  417 => "Expectation failed",
  418 => "I’m a teapot",
  421 => "Bad mapping / Misdirected Reque",
  422 => "Unprocessable entity",
  423 => "Locked",
  424 => "Method failure",
  425 => "Unordered Collection",
  426 => "Upgrade Required",
  428 => "Precondition Required",
  429 => "Too Many Requests",
  431 => "Request Header Fields Too La",
  449 => "Retry With",
  450 => "Blocked by Windows Parental Controls",
  451 => "Unavailable For Legal Reasons",
  456 => "Unrecoverable Error",
  499 => "client has closed connection",
  500 => "Internal Server Error",
  501 => "Not Implemented",
  502 => "Bad Gateway ou Proxy Error",
  503 => "Service Unavailable",
  504 => "Gateway Time-out",
  505 => "HTTP Version not supported",
  506 => "Variant also negociate",
  507 => "Insufficient storage",
  508 => "Loop detected",
  509 => "Bandwidth Limit Exceeded",
  510 => "Not extended",
  511 => "Network authentication required",
  520 => "Web server is returning an unknown error",
}.freeze

get "/" do
  redirect to("/html")
end

get "/code/:http_code" do
  code = params["http_code"].to_i
  code = KNOWN_HTTP_CODES.key?(code) ? code : 200

  halt code, KNOWN_HTTP_CODES[code.to_i]
end

get "/json" do
  content_type :json
  SAMPLE_JSON
end

get "/text" do
  content_type :text
  SAMPLE_TEXT
end

get "/xml" do
  content_type :xml
  SAMPLE_XML
end

get "/html" do
  content_type :html
  SAMPLE_HTML
end

get "/js" do
  content_type :js
  SAMPLE_JS
end

get "/s_code.js" do
  content_type :js
  SAMPLE_JS
end

get "/html_js_ad" do
  content_type :html
  SAMPLE_HTML_JS_AD
end

get "/slow" do
  sleep 10
  content_type :text
  "Hello, tired!"
end

get "/redirection/infinite" do
  redirect to("/redirection/infinite")
end

get "/redirection/temporary" do
  redirect to("/html"), 301
end

get "/redirection/local" do
  redirect to("/html")
end

get "/redirection/other_domain" do
  redirect "https://www.perdu.com"
end
