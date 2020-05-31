module Helpers
  def warden
    env['warden']
  end

  def authenticated?
    warden.authenticated?
  end

  def current_user
    warden.user
  end
end
