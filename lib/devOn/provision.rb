module DevOn
  module Provision
    #
    # This will actually provision the VM machine using the configuration provided
    #
    def provision!(conection, config)
      @tunnel = Tunnel.new(
      {
        :hostname => conection.hostname,
        :user => conection.user,
        :port => conection.port,
        :key_data =>conection.key_data
      }
      )

      stdout = ""
      @sftp = nil
      @tunnel.on_shh do |session|

        config.commands.each do |cmd|

          @sftp ||= session.sftp.connect

          if cmd.type.eql? Command::UPLOAD_FILE
            @sftp.upload!(cmd.value[:source], cmd.value[:destination], {:verbose=>@tunnel.verbose})
            @tunnel.logger.info("[Uploaded file] #{cmd.value.inspect}")
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
  end
end