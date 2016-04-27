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

  def test_200_response
    get '/code/200'

    assert last_response.ok?
    assert last_response.body.include?('OK')
  end

  def test_404_response
    get '/code/404'

    assert last_response.not_found?
    assert last_response.body.include?('Not Found')
  end

  def test_500_response
    get '/code/500'

    assert last_response.server_error?
    assert last_response.body.include?('Server Error')
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
end
