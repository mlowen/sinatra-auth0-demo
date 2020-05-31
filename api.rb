require 'sinatra/base'

class Auth0DemoAPI < Sinatra::Base

  get '/' do
    "Hello world"
  end
end
