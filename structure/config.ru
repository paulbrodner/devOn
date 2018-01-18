require "rubygems"
require "devOn"
require "devOn/server/app"

# this will run the Sinatra based app according to devOn gem
use ActiveRecord::ConnectionAdapters::ConnectionManagement
run DevOn::Server::App.run!
