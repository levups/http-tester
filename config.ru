# frozen_string_literal: true

require_relative 'app'

set :environment, ENV['RACK_ENV'].to_sym
set :bind, '0.0.0.0'

run Sinatra::Application
