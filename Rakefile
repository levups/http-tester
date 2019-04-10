# frozen_string_literal: true

require "bundler"
require "bundler/setup"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

task default: [:test]
