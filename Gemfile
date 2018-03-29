# frozen_string_literal: true

source 'https://rubygems.org'

ruby "2.5.1"

gem 'puma'
gem 'sinatra'

group :development, :test do
  gem 'pry'
  gem 'rake'
end

group :test do
  gem 'minitest'
  gem 'rack-test'

  # Code coverage & quality monitoring gems
  # The test helper file requires them as needed (during CI, locally, etc.) so
  # we use a require: false here.
  #
  # Keep both gems here as we might switch between the two coverage/quality
  # analysis tools depending on their servers' reliability, responsiveness.
  gem 'codacy-coverage',           require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov',                 require: false
end
