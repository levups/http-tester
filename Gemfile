# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.6.2"

gem "puma"
gem "sinatra"

group :development, :test do
  gem "pry"
  gem "rake"
  gem "standard"
end

group :test do
  gem "codacy-coverage", require: false
  gem "minitest"
  gem "rack-test"
end
