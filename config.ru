require_relative 'app'
require_relative 'api'

run Rack::URLMap.new(
  '/' => Auth0DemoApplication,
  '/api' => Auth0DemoAPI
)
