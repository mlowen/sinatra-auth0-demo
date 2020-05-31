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
  end
end
