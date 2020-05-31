Sequel.migration do
  up do
    create_table :users do
      primary_key :id

      String :auth0_id, null: false
      String :email, null: false

      DateTime :updated_at, null: false
      DateTime :created_at, null: false
    end
  end
end
