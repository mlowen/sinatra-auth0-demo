require_relative 'token'

module Helpers
  def warden
    env['warden']
  end

  def authenticated?
    warden.authenticated?
  end

  def authenticated!
    halt 401 unless authenticated?
  end

  def current_user
    warden.user
  end

  def token
    Token.new(current_user)
  end
end
