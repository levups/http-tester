# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.4.0'

gem 'sinatra'
gem 'puma'

group :development, :test do
  gem 'pry'
  gem 'rake'
end

group :test do
  gem 'minitest'
  gem 'rack-test'

  # Test coverage & code quality monitoring
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0"
end
