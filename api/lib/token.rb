require 'jwt'
require 'net/http'
require 'uri'
require 'json'

class Token
  @@jwks = nil

  def initialize(token)
    @token = token
    @valid = true
    @payload, @header = JWT.decode(@token, nil, true,
                                   algorithm: 'RS256',
                                   iss: ENV['AUTH0_ISSUER'],
                                   aud: ENV['AUTH0_AUDIENCE'],
                                   verify_aud: true) { |header| jwks[header['kid']] }

    @scopes = @payload['scope'].split(' ')
    @expires_at = Time.at(@payload['exp'])
    @issued_at = Time.at(@payload['iat'])
  rescue
    @valid = false
  end

  attr_reader :header
  attr_reader :scopes
  attr_reader :expires_at
  attr_reader :issued_at
  attr_reader :payload

  def valid?
    @valid
  end

  def method_missing(method, *arguments, &block)
    @payload.include?(method.to_s) ? @payload[method.to_s] : super
  end

  def respond_to_missing?(method, include_private = false)
    @payload.include?(method.to_s) || super
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
