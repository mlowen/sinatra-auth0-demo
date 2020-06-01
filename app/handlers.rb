module Handlers
  def self.registered(app)
    app.get '/' do
      erb authenticated? ? :authenticated : :unauthenticated
    end

    app.get '/auth/callback' do
      warden.authenticate!
      redirect '/'
    end

    app.get '/sign-out' do
      warden.logout
      redirect "#{ENV['AUTH0_DOMAIN']}/v2/logout?client_id=#{ENV['AUTH0_ID']}"
    end
  end
end
