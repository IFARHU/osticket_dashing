# Loading .env
require 'dotenv'
Dotenv.load
require 'dashing'
require 'mysql2'

# Configuring app
configure do
  # Global Database Configuration
  db = Mysql2::Client.new(
    :host => ENV['DATABASE_HOST'],
    :username => ENV['DATABASE_USER'],
    :password => ENV['DATABASE_PASS'],
    :port => ENV['DATABASE_PORT'],
    :database => ENV['DATABASE_DB']
  )

  # Global settings
  set :auth_token, ENV['AUTH_TOKEN']
  set :db, db

  # Helpers configuration
  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

# Loading the app
map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application