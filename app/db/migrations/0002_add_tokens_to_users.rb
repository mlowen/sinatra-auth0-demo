Sequel.migration do
  up do
    alter_table :users do
      add_column :access_token, String
      add_column :id_token, String
      add_column :refresh_token, String
      add_column :token_expires_at, Time
    end
  end
end
