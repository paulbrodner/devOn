
module DevOn
  
  # This class is defining  available commands that will be executed by lib/devOn/provision.rb module
  # * helper methods like downloading_file, uploading_file, etc
  # * the $config global variable is defined as a lib/devon/config.rb instance
  class Command
    SHELL = 1
    UPLOAD_FILE = 3
    APPLY_TEMPLATE = 4
    DOWNLOAD_FILE = 5

    attr_accessor :type
    attr_accessor :value

    # the new command will take:
    # - a 'type' - defined in the list above
    # - and the actual 'command' value
    def initialize(type, command)
      @type = type
      @value = command
    end

    #
    # downloads a <file> from server to local <destination>
    # if destination parent folder doesn't exist it will be created automatically
    #   
    def self.download_file(file, destination)
      data = {:source => file, :destination => destination}
      FileUtils.mkdir_p File.dirname(destination)
      Command.add($config, Command::DOWNLOAD_FILE, data)
    end

    #
    # uploads a <file> from local to server <destination>
    # if the local file is a ERB template, the template is automatically rendered and returned 
    # in order to be uploaded on the remote server
    #
    def self.upload_file(file, destination)
      puts "Using file for upload: #{file}"
      raise "Source file not found: #{file}" unless File.exist?(file)      
      file_name = File.basename(file)

      if file_name.include?(".erb")
        data = {:source => Template.tmp_file(file).path, :destination => destination}
      else
        data = {:source => file, :destination => destination}
      end

      Command.add($config, Command::UPLOAD_FILE, data)
    end

    #
    # run a local shell file on remote server
    # it actually upload the shell file
    # then it will mark that file executable `chmod +x` and run it
    #
    def self.run_shell_file(shell_file)
      puts "Using shell file: #{shell_file}"
      tmp_shell_file = File.join(($connection.tmp || "."), File.basename(shell_file))
      Command.upload_file(shell_file, tmp_shell_file)
      Command.run_shell "chmod +x #{tmp_shell_file} && sh #{tmp_shell_file}"
    end

    #
    # run a shell command like "ls -la:
    #
    def self.run_shell(shell_cmd)
      puts "Using shell command: #{shell_cmd}"
      Command.add($config, Command::SHELL, shell_cmd)
    end

    #
    # render a local ERB template file to server <destination>
    #
    def self.apply_template(template, destination)
      puts "Using template: #{template} for #{destination}"
      temp_data = {:file => Template.from_file(template), :destination => destination}
      Command.add($config, Command::APPLY_TEMPLATE, temp_data)
    end

    #
    # run a shell command on remote server 
    # copying the file in the same location (or new destination passed) including the iso date
    #
    def self.backup(file, destination="")
      puts "Create backup #{File.join(destination, file)}"
      Command.run_shell "cp #{file}{,.backup.`date --iso`}"
    end

    #
    # is one interactive shell, asking you for permission if you want to continue
    # @return boolean value
    #
    def self.ask_permision
      if ENV['INTERACTIVE'].eql? "true"
        yield
      else
        puts "Do you want to continue ?(y/n)"
        yield if STDIN.gets().downcase.chomp().eql?"y"
      end
    end

    #
    # kills a program based on program_name
    #
    def self.kill_program(program_name)
      program_name = program_name.insert(0,"[")
      program_name = program_name.insert(2,"]")
      Command.run_shell "kill -9 $(ps aux | grep '#{program_name}' | awk '{print $2}')"
    end

    # for debugging purposes
    def to_h
      if @value.is_a? String
        return @value
      elsif @value.is_a? Hash
        return @value.to_h
      else
        @value.inspect
      end
    end

private
    # use Command.add to create new commands in the list of configuration item
    # <config> is one instance of config.rb module
    # <cmd_type> one constant define at the top of this file
    # <data> the actual command data used
    def self.add(config, cmd_type, data)
      config.add_commands!(Command.new(cmd_type, data))
    end
  end
end
