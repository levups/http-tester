# frozen_string_literal: true

# Puma 6 defaults :
# min = ENV['PUMA_MIN_THREADS'] || ENV['MIN_THREADS']
# max = ENV['PUMA_MAX_THREADS'] || ENV['MAX_THREADS']
# workers = ENV['WEB_CONCURRENCY']

port ENV["PORT"] || 3000
rackup "config.ru"
preload_app!
