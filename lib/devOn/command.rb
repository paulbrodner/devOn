module DevOn
  class Command
    SHELL = 1
    UPLOAD_FILE = 3
    APPLY_TEMPLATE = 4
    DOWNLOAD_FILE = 5

    attr_accessor :type
    attr_accessor :value

    def initialize(type, command)
      @type = type
      @value = command
    end

    def self.download_file(file, destination)
      data = {:source => file, :destination => destination}
      FileUtils.mkdir_p File.dirname(destination)
      Command.add($config, Command::DOWNLOAD_FILE, data)
    end

    def self.upload_file(file, destination)
      raise "Source file not found: #{file}" unless File.exist? file
      puts "Using file for upload: #{file}"
      file_name = File.basename(file)

      if file_name.include?(".erb")
        data = {:source => Template.tmp_file(file).path, :destination => destination}
      else
        data = {:source => file, :destination => destination}
      end

      Command.add($config, Command::UPLOAD_FILE, data)
    end

    def self.run_shell_file(shell_file)
      puts "Using shell file: #{shell_file}"
      tmp_shell_file = File.join(($connection.tmp || "."), File.basename(shell_file))
      Command.upload_file(shell_file, tmp_shell_file)
      Command.run_shell "chmod +x #{tmp_shell_file} && sh #{tmp_shell_file}"
    end

    def self.run_shell(shell_cmd)
      puts "Using shell command: #{shell_cmd}"
      Command.add($config, Command::SHELL, shell_cmd)
    end

    def self.apply_template(template, destination)
      puts "Using template: #{template} for #{destination}"
      temp_data = {:file => Template.from_file(template), :destination => destination}
      Command.add($config, Command::APPLY_TEMPLATE, temp_data)
    end

    def self.backup(file, destination="")
      puts "Create backup #{File.join(destination, file)}"
      Command.run_shell "cp #{file}{,.backup.`date --iso`}"
    end

    #
    # kills a program based on program_name
    #
    def self.kill_program(program_name)
      program_name = program_name.insert(0,"[")
      program_name = program_name.insert(2,"]")
      Command.run_shell "kill -9 $(ps aux | grep '#{program_name}' | awk '{print $2}')"
    end

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
    #
    def self.add(config, cmd_type, data)
      config.add_commands!(Command.new(cmd_type, data))
    end
  end
end
