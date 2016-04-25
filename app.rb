require 'bundler'
require 'bundler/setup'
require 'sinatra'

get '/' do
  "Hello, world!"
end

get '/404' do
  halt 404, "Not Found"
end

get '/500' do
  halt 500, "Server Error"
end

get '/infinite' do
  redirect '/infinite'
end

get '/slow' do
  sleep 5

  "Hello, tired!"
end
