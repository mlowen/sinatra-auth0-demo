require 'sinatra/base'

require_relative 'lib/token_middleware'
require_relative 'helpers'

class Auth0DemoAPI < Sinatra::Base
  use TokenMiddleware

  helpers Helpers

  get '/' do
    can! 'profile'

    "Hello world #{token.sub}"
  end

  get '/fails' do
    can! 'unknown:scope'

    'We should not get here'
  end
end
