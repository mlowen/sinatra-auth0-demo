namespace :db do
  desc 'Run migrations'

  task :migrate do
    require 'sequel'

    migrations = File.join(__dir__, 'app/db/migrations')
    database = Sequel.connect('sqlite://auth0-test.db')

    Sequel.extension :migration
    Sequel::Migrator.run(database, migrations)
  end
end
