# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.6.1"

gem "puma"
gem "sinatra"

group :development, :test do
  gem "pry"
  gem "rake"
end

group :test do
  gem "codacy-coverage", require: false
  gem "minitest"
  gem "rack-test"
end
