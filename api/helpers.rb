module Helpers
  def token
    env['AUTH_TOKEN']
  end

  def can!(scope)
    halt 403, 'forbidden' unless token.scopes.include?(scope)
  end
end
