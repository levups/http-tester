# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../app"

# This is the main app tests
class MainAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_default_response
    get "/"
    follow_redirect!

    assert_predicate last_response, :ok?
    assert_includes last_response.body, "Hello World"
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
    get "/slow"
    after_time = Time.now
    duration = after_time.to_f - before_time.to_f

    assert_predicate last_response, :ok?
    assert_includes last_response.body, "Hello, tired!"
    assert_operator duration, :>=, 10.0
  end

  def test_xml
    get "/xml"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_XML
    assert_equal last_response.body.size, SAMPLE_XML.size
  end

  def test_html
    get "/html"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_HTML
    assert_equal last_response.body.size, SAMPLE_HTML.size
  end

  def test_js
    get "/js"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_JS
    assert_equal last_response.body.size, SAMPLE_JS.size
  end

  def test_js_ad
    get "/s_code.js"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_JS
    assert_equal last_response.body.size, SAMPLE_JS.size
  end

  def test_html_js_ad
    get "/html_js_ad"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_HTML_JS_AD
    assert_equal last_response.body.size, SAMPLE_HTML_JS_AD.size
  end

  def test_json
    get "/json"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_JSON
    assert_equal last_response.body.size, SAMPLE_JSON.size
  end

  def test_text
    get "/text"

    assert_predicate last_response, :ok?
    assert_includes last_response.body, SAMPLE_TEXT
    assert_equal last_response.body.size, SAMPLE_TEXT.size
  end

  def test_local_redirection_with_follow_redirect
    get "/redirection/local"
    follow_redirect!

    assert_predicate last_response, :ok?
    assert_equal("http://example.org/html", last_request.url)
    assert_includes last_response.body, "Hello World"
  end

  def test_local_redirection_without_follow_redirect
    get "/redirection/local"

    assert_equal(302, last_response.status)
    assert_equal("http://example.org/html", last_response.headers["Location"])
  end

  def test_temporary_redirection
    get "/redirection/temporary"

    assert_equal(301, last_response.status)
    assert_equal("http://example.org/html", last_response.headers["Location"])
  end

  def test_redirection_to_other_domain
    get "/redirection/other_domain"

    assert_equal(302, last_response.status)
    assert_equal("https://www.perdu.com", last_response.headers["Location"])
  end

  def test_infinite_redirection
    get "/redirection/infinite"

    assert_equal(302, last_response.status)
    assert_equal("http://example.org/redirection/infinite", last_request.url)
  end

  private

  def no_body_expected?(code)
    [204, 205, 304].include? code
  end
end
