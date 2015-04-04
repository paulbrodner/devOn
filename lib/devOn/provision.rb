module DevOn
  module Provision
    #
    # This will actually provision the VM machine using the configuration provided
    #
    def provision!(conection, config)
      @tunnel = Tunnel.new(conection.to_h)

      stdout = ""
      @sftp = nil
      @tunnel.on_shh do |session|

        config.commands.each do |cmd|
          catch_sftp_exception do
            @sftp ||= session.sftp.connect
          end

          if cmd.type.eql? Command::UPLOAD_FILE
            catch_sftp_exception do
              @sftp.upload!(cmd.value[:source], cmd.value[:destination], {:verbose=>@tunnel.verbose})
              @tunnel.logger.info("[File UPLOADED] #{cmd.value.inspect}")
            end
          end

          if cmd.type.eql? Command::SHELL
            ap "Running command: #{cmd.value}"
            session.exec!(cmd.value) do |channel, stream, data|
              stdout << data if stream == :stdout
            end
            puts "[SHELL OUTPUT]\n#{stdout}"
          end        
        end
      end
    end

    private
    def catch_sftp_exception(&block)
      yield block
    rescue Net::SFTP::StatusException => e
      raise "Couldn't execute SFTP command: #{e.message}"
    end
  end
end