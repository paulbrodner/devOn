module DevOn
  module Provision
    #
    # This will actually provision the VM machine using the configuration provided
    #
    def provision!(conection, config)
      @t = Tunnel.new(
      {
        :hostname => conection.hostname,
        :user => conection.user,
        :port => conection.port,
        :key_data =>conection.key_data
      }
      )

      @t.on_shh do |ssh|
        stdout = ""
        ssh.exec!("ls -la ") do |channel, stream, data|
          stdout << data if stream == :stdout
        end
        puts stdout
      end
    end
  end
end