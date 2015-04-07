module DevOn
  class Command
    SHELL = 1
    UPLOAD_FILE = 3
    APPLY_TEMPLATE = 4

    attr_accessor :type
    attr_accessor :value
    def initialize(type, command)
      @type = type
      @value = command
    end

    def self.upload_file(config, file, destination)
      raise "Source file not found: #{file}" unless File.exist? file
      puts "Using file for upload: #{file}"
      file_name = File.basename(file)

      if file_name.include?(".erb")
        data = {:source => Template.tmp_file(file).path, :destination => destination}
      else
        data = {:source => file, :destination => destination}
      end

      Command.add(config, Command::UPLOAD_FILE, data)
    end

    def self.run_shell_file(config, shell_file)
      puts "Using shell file: #{shell_file}"
      tmp_shell_file = File.join((config.tmp || "."), File.basename(shell_file))
      Command.upload_file(config,shell_file, tmp_shell_file)
      Command.add(config, Command::SHELL, "chmod +x #{tmp_shell_file} && sh #{tmp_shell_file}")
    end

    def self.run_shell(config, shell_cmd)
      puts "Using shell command: #{shell_cmd}"
      Command.add(config, Command::SHELL, shell_cmd)
    end

    def self.apply_template(config, template, destination)
      puts "Using template: #{template} for #{destination}"
      temp_data = {:file=> Template.from_file(template), :destination=>destination}
      Command.add(config, Command::APPLY_TEMPLATE,temp_data)
    end

    def to_h
      @value.to_h
    end

    private

    # use Command.add to create new commands in the list of configuration item
    #
    def self.add(config, cmd_type, data)
      config.add_commands!(Command.new(cmd_type, data))
    end

  end
end
