require 'rake'
require 'awesome_print'

include Rake::DSL

namespace :scripts do
  desc "Create a new script"
  task :new do
    puts "What is the script name?(ex: install_41) :"
    name = STDIN.gets.chomp
    template=%"
module #{name.capitalize}
  include DevOn
  # use gloabl variable of the current connection selected
  # $connection.settings
  # or of the current configuration
  # $config.name
  #
  # Command.run_shell_file(\"install/test.sh\")
  # Command.run_shell(\"ls -la /tmp\")
  # Command.run_shell(\"rm -rf /tmp/fromFile\")
  # Command.run_shell(\"ls -la /tmp\")
  # Command.upload_file(\"<source>/example.erb.rb\", \"/home/vagrant/test.rb\")
  #
  # and provision the machine with:
  # provision_on $config
end
  "
    create_structure("scripts",name, template)
  end

  desc "List available scripts "
  task :list do
    list "scripts"
  end

  desc "Run script"
  task :run do
    require 'devOn'

    script = interactive "scripts"
    connection = interactive "connections"

    require File.expand_path(connection)

    config = interactive "configs"

    $connection = DevOn::Config.send(ENV['connections'])

    exit if not_continue?(
    {
      :connection=>
      {
        :file =>connection,
        :value=> $connection.settings
      },
      :script =>script,
      :connfiguration => config
    })

    if ENV['configs']
      require File.expand_path(config)
      $config = DevOn::Config.send(ENV['configs'])
    else
      $config = DevOn::Config.on "default" do
        name "default_config"
      end
    end

    require File.expand_path(script)
  end
end

namespace :configs do
  desc "Create a new Configuration"
  task :new do
    puts "What is the configuration name?(ex: bm_node1) :"
    name = STDIN.gets.chomp

    template=%"
module #{name.capitalize}
  include DevOn

  Config.on \"#{name}\" do
    key1 do
      a1 '1'
      a2 '2'
    end
    key2 'key2'
  end
end
  "
    create_structure("configs",name, template)
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
  _folder = Dir["#{folder}/*.rb"]
  return [] if _folder.empty?
  DevOn::print "Available #{folder.capitalize}:"
  DevOn::print _folder
  _folder
end

def create_structure(on, name,template)
  config = File.join(on, name + ".rb")
  raise "File #{File.expand_path(config)} already exists!" if File.exist?(config)

  FileUtils.mkdir_p(File.join(on, name))

  File.write(config, template)
  puts "Created structure for #{config}!"
end

def not_continue?(message)
  puts "\e[H\e[2J"
  DevOn::print "Running the following settings:"
  DevOn::print message
  DevOn::print "Continue?(y/n):"
  r = STDIN.gets.chomp
  return r.downcase.eql?("n")
end

def interactive(folder)
  all_files = list(folder)
  return if all_files.empty?
  puts "Choose a file from #{folder} to use:"
  id_file = STDIN.gets.chomp.to_i || 0
  file_path = all_files[id_file]
  ENV[folder] =  File.basename(file_path, ".rb")
  file_path
end