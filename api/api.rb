require 'sinatra/base'

require_relative 'lib/token_middleware'
require_relative 'helpers'

class Auth0DemoAPI < Sinatra::Base
  use TokenMiddleware

  configure do
    enable :cross_origin
  end

  helpers Helpers

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  options '*' do
    response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept'
    response.headers['Access-Control-Allow-Origin'] = '*'

    200
  end

  get '/success' do
    can! 'profile'

    "Hello world #{token.sub}"
  end

  get '/fails' do
    can! 'unknown:scope'

    'We should not get here'
  end
end
