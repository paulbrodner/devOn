# coding: utf-8
require 'sinatra'
require 'sinatra/base'
require 'erb'
require 'will_paginate'
require 'will_paginate/array'
require "will_paginate-bootstrap"
require "devOn/server/db/base"
require "devOn/server/db/history"
require "devOn/tasks"
require 'open3'

module DevOn::Server

  class App < Sinatra::Base
    include WillPaginate::Sinatra::Helpers
    #set :bind, '10.11.12.27'
    set :root, "server"
    set :public_folder, File.join(File.expand_path('..', __FILE__),"static")
    set :views, File.expand_path('../views', __FILE__)

    get '/' do
      histories
      erb :history
    end

    get '/execute' do
      @scripts = Dir["#{ID_SCRIPTS}/*.rb"]
      @connections = Dir["#{ID_CONN}/*.rb"]
      @configurations = Dir["#{ID_CONFIGS}/*.rb"]
      erb :execute
    end

    post '/execute' do
      run_command(params[:script],params[:connection],params[:configuration])
      erb :results
    end

    get '/run/:history_id' do
      history = History.find_by(:id=>params[:history_id])
      run_command(history.script,history.connection,history.configuration)
      erb :results
    end

    private
    def histories(display=10)
      @histories =  History.all
    end

    def run_command(script,connection,configuration)
      cmd = "'#{script}','#{connection}','#{configuration}'"
      rake = "rake scripts:run_all[#{cmd}] INTERACTIVE=false"
      rake_output, s = Open3.capture2e rake

      History.create(:script => script,
                     :connection => connection,
                     :configuration => configuration,
                     :results => rake_output);
      @results = "Running the following rake task: #{rake}\n\n"
      @results += rake_output
    end
  end
end

