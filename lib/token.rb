require 'jwt'
require 'net/http'
require 'uri'
require 'json'

class Token
  @@jwks = nil

  def initialize(token)
    @token = token
    @valid = true
    @jwt = JWT.decode(@token, nil, true,
                      algorithm: 'RS256',
                      iss: 'https://lowen.auth0.com/',
                      aud: 'http://localhost:9292',
                      verify_aud: true) { |header| jwks[header['kid']] }
  rescue
    @valid = false
  end

  attr_reader :jwt

  def valid?
    @valid
  end

  private

  def jwks
    return @@jwks unless @@jwks.nil?

    raw = JSON.parse(Net::HTTP.get(URI(ENV['AUTH0_JWKS_URI'])))
    pairs = raw['keys'].map do |k|
      [
        k['kid'],
        OpenSSL::X509::Certificate.new(Base64.decode64(k['x5c'].first)).public_key
      ]
    end

    @@jwks = Hash[pairs]
  end
end
