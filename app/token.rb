require 'json'
require 'time'
require 'net/http'

class Token
  def initialize(user)
    @user = user
  end

  def expires_at
    @user.token_expires_at
  end

  def expired?
    expires_at < Time.now
  end

  def refresh
    result = Net::HTTP.post_form(URI("#{ENV['AUTH0_DOMAIN']}/oauth/token"),
                                 'grant_type' => 'refresh_token',
                                 'client_id' => ENV['AUTH0_ID'],
                                 'client_secret' => ENV['AUTH0_SECRET'],
                                 'refresh_token' => @user.refresh_token)

    raise 'Error refreshing token' unless result.is_a?(Net::HTTPSuccess)

    @user.update_tokens(JSON.parse(result.body))
  end

  def to_s
    refresh if expired?

    @user.access_token
  end

  def to_json(_)
    JSON.dump('token' => to_s, 'expires_at' => expires_at.iso8601)
  end
end
