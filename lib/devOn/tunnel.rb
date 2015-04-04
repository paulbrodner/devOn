module DevOn
  require 'net/ssh'
  require 'net/sftp'

  class Tunnel
    #
    # Creates a Tunnel connection and execute custom commands
    #
    attr_accessor :hostname
    attr_accessor :user
    attr_accessor :port
    attr_reader :key_data
    attr_accessor :verbose
    attr_accessor :logger
    def initialize(config)
      #
      # configure connection based on Config provided
      #
      @hostname = config[:hostname]
      @user = config[:user]
      @port = config[:port]
      @verbose = config[:verbose] || :info

      raise Exception, "Hostname should be provided" if @hostname.nil?
      raise Exception, "User should be provided" if @user.nil?

      if config[:key_data]
        raise "Key Data not found: #{File.expand_path(config[:key_data])}" unless File.exist? config[:key_data]
        puts "Connecting #{@user}@#{@hostname}:#{@port} using Key Data: #{config[:key_data]}"
        @key_data = File.read(config[:key_data])
      end

    end

    def on_shh
      if @key_data
        Net::SSH.start(@hostname, @user, :port=> @port, :key_data => @key_data, :verbose=>(@verbose) ) do |session|
          @logger = session.logger
          yield session
        end
      end
    end  
  end
end