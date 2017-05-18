# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

# Local code coverage analysis
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'

# If we monitor coverage using Codacy, don't use any other coverage
# analysis tool. That's why we use a "elsif"
elsif ENV['CODACY_PROJECT_TOKEN']
  require 'codacy-coverage'
  Codacy::Reporter.start

# Code Climate recommands initializing before everything else, and not using
# SimpleCov's Rails specific web page generation presets.
elsif ENV['CODECLIMATE_REPO_TOKEN']
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'
require 'rack/test'

require_relative '../app'

# This is the main app tests
class MainAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_default_response
    get '/'
    follow_redirect!

    assert last_response.ok?
    assert_includes last_response.body, 'Hello World'
  end

  KNOWN_HTTP_CODES.each do |code, content|
    define_method "test_#{code}_response" do
      get "/code/#{code}"

      assert_equal last_response.status, code
      assert_includes(last_response.body, content) unless no_body_expected?(code)
    end
  end

  def test_slow_response
    before_time = Time.now
    get '/slow'
    after_time = Time.now
    duration   = after_time.to_f - before_time.to_f

    assert last_response.ok?
    assert_includes last_response.body, 'Hello, tired!'
    assert_operator duration, :>=, 10.0
  end

  def test_xml
    get '/xml'

    assert last_response.ok?
    assert_includes last_response.body, SAMPLE_XML
    assert_equal last_response.body.size, SAMPLE_XML.size
  end

  def test_html
    get '/html'

    assert last_response.ok?
    assert_includes last_response.body, SAMPLE_HTML
    assert_equal last_response.body.size, SAMPLE_HTML.size
  end

  def test_json
    get '/json'

    assert last_response.ok?
    assert_includes last_response.body, SAMPLE_JSON
    assert_equal last_response.body.size, SAMPLE_JSON.size
  end

  def test_text
    get '/text'

    assert last_response.ok?
    assert_includes last_response.body, SAMPLE_TEXT
    assert_equal last_response.body.size, SAMPLE_TEXT.size
  end

  def test_local_redirection_with_follow_redirect
    get '/redirection/local'
    follow_redirect!

    assert last_response.ok?
    assert_equal last_request.url, 'http://example.org/html'
    assert_includes last_response.body, 'Hello World'
  end
  end

  private

  def no_body_expected?(code)
    [204, 205, 304].include? code
  end
end
