module DevOn
  module Provision
    def provision_on(config)
      provision!(config.connection, config)
    end

    def use_file(config, filename)
      raise "No configs files found for: #{config.inspect}" if  !config.files
      f = config.files.select{|f| f.include?(filename)}.first
      raise "File #{filename} not found in configs folder of the script" if f.nil?
      f
    end

    #
    # This will actually provision the VM machine using the configuration provided
    #
    def provision!(conection, config)
      return if config.commands.nil?

      @tunnel = Tunnel.new(conection.to_h)
      @errors = []

      stdout = ""
      @sftp = nil
      @tunnel.on_shh do |session|
        config.commands.each do |cmd|
          catch_sftp_exception do
            @sftp ||= session.sftp.connect
          end

          if cmd.type.eql? Command::UPLOAD_FILE
            catch_sftp_exception do
              ap "Preparing SFTP Upload command:"
              ap cmd.value
              @sftp.upload!(cmd.value[:source], cmd.value[:destination], {:verbose=>@tunnel.verbose})
              print("[File UPLOADED: #{cmd.value[:destination]}!")
              print cmd.value
            end
          end

          if cmd.type.eql? Command::SHELL
            catch_ssh_exception do
              ap "Preparing SSH command:"
              print cmd.to_h
              session.exec!(cmd.value) do |channel, stream, data|
                stdout << data if stream == :stdout
              end
              ap "[SHELL OUTPUT]"
              print stdout
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

    def print(info)

      ap info, options = {:indent=>4, :multiline=>true,
        :color => {
        :args       => :pale,
        :array      => :white,
        :bigdecimal => :blue,
        :class      => :yellow,
        :date       => :greenish,
        :falseclass => :red,
        :fixnum     => :blue,
        :float      => :blue,
        :hash       => :pale,
        :keyword    => :cyan,
        :method     => :purpleish,
        :nilclass   => :red,
        :rational   => :blue,
        :string     => :yellowish,
        :struct     => :pale,
        :symbol     => :cyanish,
        :time       => :greenish,
        :trueclass  => :green,
        :variable   => :cyanish
        }
      }
    end

    def catch_sftp_exception(&block)
      yield block
    rescue Exception => e
      @errors.push(e.message)
      print "SFTP ERRORS"
      print @errors
      raise e
    end

    def catch_ssh_exception(&block)
      yield block
    rescue Exception => e
      @errors.push(e.message)
      print "SSH ERRORS"
      print @errors
      raise e
    end
  end
end