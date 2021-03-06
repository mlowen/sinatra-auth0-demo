require_relative './token'

class TokenMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) if env['REQUEST_METHOD'] == 'OPTIONS'

    prefix = 'Bearer '
    auth_header = env['HTTP_AUTHORIZATION']
    error_headers = { "Content-Type" => "text/plain" }

    return [401, error_headers, ['No token']] if auth_header.nil? or !auth_header.start_with?(prefix)

    token = Token.new(auth_header[prefix.length ..])

    return [401, error_headers, ['Invalid token']] unless token.valid?

    @app.call(env.merge('AUTH_TOKEN' => token))
  end
end
