require_relative 'app/app'
require_relative 'api/api'

run Rack::URLMap.new(
  '/' => Auth0DemoApplication,
  '/api' => Auth0DemoAPI
)
