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
    assert last_response.body.include?('OK')
  end

  KNOWN_HTTP_CODES.each do |code, content|
    define_method "test_#{code}_response" do
      get "/code/#{code}"

      assert last_response.status == code
      assert last_response.body.include?(content) unless no_body_expected?(code)
    end
  end

  def test_slow_response
    get '/slow'

    assert last_response.ok?
    assert last_response.body.include?('Hello, tired!')
  end

  def test_infinite_response
    get '/infinite'

    assert last_response.status == 302
    assert_equal 'http://example.org/infinite', last_request.url
  end

  def test_xml
    get '/xml'

    assert last_response.ok?
    assert last_response.body.include?(SAMPLE_XML)
  end

  def test_json
    get '/json'

    assert last_response.ok?
    assert last_response.body.include?(SAMPLE_JSON)
  end

  def test_text
    get '/text'

    assert last_response.ok?
    assert last_response.body.include?(SAMPLE_TEXT)
  end

  private

  def no_body_expected?(code)
    [204, 205, 304].include? code
  end
end
