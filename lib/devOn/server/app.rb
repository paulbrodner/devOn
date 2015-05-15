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

    get '/run/:script/:connection/:config' do
      cmd = "#{params[:script]},#{params[:connection]},#{params[:config]}"
      @results = `rake scripts:run_all[#{cmd}] INTERACTIVE=false`
      erb :results
    end

    def minutes_in_words(timestamp)
      minutes = (((Time.now - timestamp).abs)/60).round
      return nil if minutes < 0
      m =case minutes
           when 0..4 then
             '5 minutes'
           when 5..14 then
             '15 minutes'
           when 15..29 then
             '30 minutes'
           when 30..59 then
             '30 minutes'
           when 60..119 then
             '1 hour'
           when 120..239 then
             '2 hours'
           when 240..479 then
             '4 hours'
           when 480..719 then
             '8 hours'
           when 720..1439 then
             '12 hours'
           when 1440..11519 then
             "#{(minutes/1440).floor}" << " day".pluralize
           when 11520..43199 then
             "#{(minutes/11520).floor}" <<" week".pluralize
           when 43200..525599 then
             "#{(minutes/43200).floor}" <<" month".pluralize
           else
             "#{(minutes/525600).floor}" << " year".pluralize
         end
      m << " ago"
    end

    private
    def histories(display=10)
      @histories =  History.all
    end

  end
end

