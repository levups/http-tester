# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'codacy-coverage'

Codacy::Reporter.start

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
      unless no_body_expected?(code)
        assert_includes(last_response.body, content)
      end
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

  def test_local_redirection_without_follow_redirect
    get '/redirection/local'

    assert_equal last_response.status, 302
    assert_equal last_response.headers["Location"], 'http://example.org/html'
  end

  def test_temporary_redirection
    get '/redirection/temporary'

    assert_equal last_response.status, 301
    assert_equal last_response.headers["Location"], 'http://example.org/html'
  end

  def test_redirection_to_other_domain
    get '/redirection/other_domain'

    assert_equal last_response.status, 302
    assert_equal last_response.headers["Location"], 'https://www.google.fr'
  end

  def test_infinite_redirection
    get "/redirection/infinite"

    assert_equal last_response.status, 302
    assert_equal last_request.url, 'http://example.org/redirection/infinite'
  end

  private

  def no_body_expected?(code)
    [204, 205, 304].include? code
  end
end
