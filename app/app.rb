require 'rack-protection'

require 'sequel'
require 'sinatra/base'

require 'omniauth'
require 'omniauth-auth0'
require 'warden'

Sequel::Model.db = Sequel.connect('sqlite://auth0-test.db')

require_relative 'db/models/user'
require_relative 'handlers'
require_relative 'helpers'

class Auth0DemoApplication < Sinatra::Base
  OmniAuth.config.allowed_request_methods = [:post]

  use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
  use Rack::Protection::AuthenticityToken

  use OmniAuth::Builder do
    provider(
      :auth0,
      ENV['AUTH0_ID'],
      ENV['AUTH0_SECRET'],
      ENV['AUTH0_DOMAIN'],
      callback_path: '/auth/callback',
      authorize_params: {
        scope: 'openid email profile offline_access',
        audience: ENV['AUTH0_AUDIENCE']
      }
    )
  end

  use Warden::Manager do |config|
    config.serialize_into_session(&:id)
    config.serialize_from_session { |id| Models::User.first(id: id) }
    config.default_strategies :auth0
  end

  Warden::Strategies.add(:auth0) do
    def valid?
      env.key? 'omniauth.auth'
    end

    def authenticate!
      omniauth = env['omniauth.auth']

      user = Models::User.first(auth0_id: omniauth['uid'])

      if user.nil?
        user = Models::User.create(
          auth0_id: omniauth['uid'],
          email: omniauth['info']['email'],
          access_token: omniauth['credentials']['token'],
          id_token: omniauth['credentials']['id_token'],
          refresh_token: omniauth['credentials']['refresh_token'],
          token_expires_at: Time.at(omniauth['credentials']['expires_at'])
        )

        success! user
      else
        user.access_token = omniauth['credentials']['token']
        user.id_token = omniauth['credentials']['id_token']
        user.refresh_token = omniauth['credentials']['refresh_token']
        user.token_expires_at = Time.at(omniauth['credentials']['expires_at'])
        user.save

        success! user
      end
    end
  end

  helpers Helpers
  register Handlers
end
