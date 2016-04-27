ENV['RACK_ENV'] = 'test'

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

  private

  def no_body_expected?(code)
    [204, 205, 304].include? code
  end
end
