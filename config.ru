require_relative 'app'
require 'rack-timeout'

set :environment, ENV['RACK_ENV'].to_sym
set :bind, '0.0.0.0'

run Sinatra::Application

