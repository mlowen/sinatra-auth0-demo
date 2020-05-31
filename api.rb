require 'sinatra/base'

require_relative 'lib/token_middleware'

class Auth0DemoAPI < Sinatra::Base
  use TokenMiddleware

  get '/' do
    "Hello world"
  end
end
