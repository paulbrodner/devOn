require "rubygems"
require "devOn"
require "devOn/server/app"

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run DevOn::Server::App.run!
