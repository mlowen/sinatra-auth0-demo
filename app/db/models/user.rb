module Models
  class User < Sequel::Model
    plugin :validation_helpers

    def validate
      validates_presence %i[auth0_id email]
    end

    def before_save
      self.created_at ||= Time.now.utc
      self.updated_at = Time.now.utc

      super
    end

    def update_tokens(token_data)
      self.access_token = token_data['access_token']
      self.id_token = token_data['id_token']
      self.refresh_token = token_data['refresh_token']
      self.token_expires_at = Time.now + token_data['expires_in']

      self.save
    end
  end
end
