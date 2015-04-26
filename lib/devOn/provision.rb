module DevOn
  module Provision
    def use_file(config, filename)
      return if config.name.eql? "default"
      raise "No configs files found for: #{config.name}" if !config.files
      f = config.files.select { |f| f.include?(filename) }.first
      raise "File #{filename} not found in configs folder of the script" if f.nil?
      f
    end

    #
    # check the OS type
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

      @tunnel = Tunnel.new($connection.settings.to_h)
      @errors = []

      stdout = []
      @sftp = nil
      @tunnel.on_shh do |session|
        config.commands.each do |cmd|
          catch_sftp_exception do
            @sftp ||= session.sftp.connect
          end

          if cmd.type.eql? Command::DOWNLOAD_FILE
            catch_sftp_exception do
              DevOn::print({:title => "Preparing SFTP Download", :value => cmd.value})
              @sftp.download!(cmd.value[:source], cmd.value[:destination], {:verbose => @tunnel.verbose})
              DevOn::print({:title => "File Download Complete", :value => cmd.value[:destination]})
            end
          end

          if cmd.type.eql? Command::UPLOAD_FILE
            catch_sftp_exception do
              DevOn::print({:title => "Preparing SFTP Upload", :value => cmd.value})
              @sftp.upload!(cmd.value[:source], cmd.value[:destination], {:verbose => @tunnel.verbose})
              DevOn::print({:title => "File Uploaded", :value => cmd.value[:destination]})
            end
          end

          if cmd.type.eql? Command::SHELL
            catch_ssh_exception do
              DevOn::print({:title => "Preparing SSH command", :value => cmd.value})
              session.exec!(cmd.value) do |channel, stream, data|
                if stream == :stdout
                  arr = data.split("\n")
                  stdout = arr.empty? ? data : arr
                end
              end
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
    end

    private

    def catch_sftp_exception(&block)
      yield block
    rescue Exception => e
      @errors.push(e.message)
      DevOn::print "SFTP ERRORS"
      DevOn::print @errors
      raise e.backtrace
    end

    def catch_ssh_exception(&block)
      yield block
    rescue Exception => e
      @errors.push(e.message)
      DevOn::print "SSH ERRORS"
      DevOn::print @errors
      raise e.backtrace
    end

    def check_compatibility!(config)
      return if config.compatibility.nil?
      unless config.compatibility.include?(ENV['scripts'])
        DevOn::print({:error => "Script '#{ENV['scripts']}' is not compatible in current configuration!", :solution => "In configuration file, add:  Config.#{ENV['configs']}.add_compatibility!('#{ENV['scripts']}'s)"})
        exit
      end
    end
  end
end