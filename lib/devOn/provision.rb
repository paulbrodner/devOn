module DevOn
  module Provision
    
    #
    # use the <filename> defined in "config" folder    
    #
    def use_file(config, filename)
      return if config.name.eql? "default"
      raise "No configs files found for: #{config.name}" if !config.files
      f = config.files.select { |f| f.include?(filename) }.first
      raise "File #{filename} not found in configs folder [#{config.name}] of the script" if f.nil?
      f
    end

    #
    # check the current OS type is the one set as parameter  
    #
    def is_os(os)
      $connection.os.eql? os
    end
    
    #
    # This will actually provision the VM machine using the configuration provided
    #
    def provision_on(config)
      check_compatibility!(config)

      return if config.commands.nil?

      # this will initialize the SSH tunnel based on the connection settings
      @tunnel = Tunnel.new($connection.settings.to_h)
      @errors = []

      @results = nil

      stdout = []
      @sftp = nil
      @tunnel.on_shh do |session|
        while config.commands.count > 0
          cmd = config.commands.shift
          
          if cmd.type.eql? Command::DOWNLOAD_FILE
            catch_sftp_exception do
              @sftp = init_sftp
              DevOn::print({:title => "Preparing SFTP Download", :value => cmd.value})
              @sftp.download!(cmd.value[:source], cmd.value[:destination], {:verbose => @tunnel.verbose})
              DevOn::print({:title => "File Download Complete", :value => cmd.value[:destination]})
            end
          end

          if cmd.type.eql? Command::UPLOAD_FILE
            catch_sftp_exception do
              @sftp = init_sftp
              DevOn::print({:title => "Preparing SFTP Upload", :value => cmd.value})
              @sftp.upload!(cmd.value[:source], cmd.value[:destination], {:verbose => @tunnel.verbose})
              DevOn::print({:title => "File Uploaded", :value => cmd.value[:destination]})
            end
          end

          if cmd.type.eql? Command::SHELL
            catch_ssh_exception do 
              command = cmd.value
              command = command.gsub("$output", $output) if(command.include?"$output")                
            
              DevOn::print({:title => "Preparing SSH command", :value => command})
              session.exec!(command) do |channel, stream, data|
                if stream == :stdout
                  arr = data.split("\n")
                  stdout = arr.empty? ? data : arr
                  @results = stdout
                end
              end
              $output = stdout.flatten.join(' ')
              DevOn::print({:title => "[SHELL OUTPUT]", :output => stdout})
            end
          end
        end
      end
      
      if !@errors.empty?
        ap "Please correct the following ERRORS:"
        ap @errors
      else
        ap "NO ERRORS ENCOUNTERED!"
      end

      @results
    end

private

    def init_sftp
      catch_sftp_exception do
        @sftp ||= session.sftp.connect
      end
      return @sftp
    end

    # catch the sftp exceptions thrown by the block code
    def catch_sftp_exception(&block)
      yield block
    rescue Exception => e
      @errors.push(e.message)
      DevOn::print "SFTP ERRORS"
      DevOn::print @errors
      raise e.backtrace
    end

    # catch the sftp exceptions thrown by the block code
    def catch_ssh_exception(&block)
      yield block
    rescue Exception => e
      @errors.push(e.message)
      DevOn::print "SSH ERRORS"
      DevOn::print @errors
      raise e.backtrace
    end

    # check if script that we want to run is compatible in current configuration
    def check_compatibility!(config)
      return if config.compatibility.nil?
      unless config.compatibility.include?(ENV['scripts'])
        DevOn::print({:error => "Script '#{ENV['scripts']}' is not compatible in current configuration!", :solution => "In configuration file, add:  Config.#{ENV['configs']}.add_compatibility!('#{ENV['scripts']}')"})
        exit
      end
    end
  end
end
