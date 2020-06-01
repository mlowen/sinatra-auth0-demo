require 'json'
require 'time'

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

  def to_s
    @user.access_token
  end

  def to_json(_)
    JSON.dump('token' => to_s, 'expires_at' => expires_at.iso8601)
  end
end
