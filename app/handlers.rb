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

    app.get '/token' do
      authenticated!

      json token
    end

    app.get %r{/api/(.*)} do |api_path|
      authenticated!

      uri = URI("#{ENV['AUTH0_AUDIENCE']}/#{api_path}")
      req = Net::HTTP::Get.new(uri)
      req["Authorization"] = "Bearer #{token}"

      result = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

      status result.code
      result.body
    end
  end
end
