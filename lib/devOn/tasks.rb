require 'rake'
require 'awesome_print'

include Rake::DSL

namespace :scripts do
  desc "Create a new script"
  task :new do
  end

  desc "List available scripts "
  task :list do
    list "scripts"
  end

  desc "Run script"
  task :run do
    require 'devOn'
    all_connections = list "connections"
    puts "Choose a connection to use:"
    id_conn = STDIN.gets.chomp.to_i
    ENV['connection'] = File.basename(all_connections[id_conn])
    require File.expand_path(all_connections[id_conn])

    all_scripts = list "scripts"
    puts "Choose a script to run:"
    id_script = STDIN.gets.chomp.to_i

    all_configs = list "configs"
    puts "Choose a configuration for the script:"
    id_config = STDIN.gets.chomp.to_i
    ENV["config"] = File.basename(all_configs[id_config],".rb")

    return if not_continue? "I will run on[#{all_connections[id_conn]}] connection, script: [#{all_scripts[id_script]}] using [#{all_configs[id_config]}]. Continue?(y/n)"

    require File.expand_path(all_scripts[id_script])
  end
end

namespace :configs do
  desc "Create a new Configuration"
  task :new do
    create_structure("configs")
  end

  desc "List available configurations"
  task :list do
    list "configs"
  end
end

namespace :conn do
  desc "List available connections"
  task :list do
    list "connections"
  end
end

private
require 'fileutils'

def list(folder)
  ap "Available #{folder.capitalize}:"
  _folder = Dir["#{folder}/*.rb"]
  ap _folder
  _folder
end

def create_structure(on)
  puts "Configuration file name?(ex: amazon-test) :"
  name = STDIN.gets.chomp

  config = File.join(on, name + ".rb")
  raise "Configuration file #{File.expand_path(config)} already exists!" if File.exist?(config)

  FileUtils.mkdir_p(File.join(on, name))
  template=%"
module #{name.capitalize}
  include DevOn

  Config.on \"#{name}\" do
    connection do
      hostname '127.0.0.1'
      username '<change-me>'
      password '<change-me>'
      port 2222
      #key_data 'configs/#{name}/private_key'
    end
    tmp '/tmp'
  end
end
"
  File.write(config, template)
  puts "Created structure for #{config}. Please update the file accordingly!"
end

def not_continue?(message)
  puts message
  r = STDIN.gets.chomp
  return r.downcase.eql?("n")
end