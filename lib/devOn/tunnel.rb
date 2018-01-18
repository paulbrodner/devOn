module DevOn
  require 'net/ssh'
  require 'net/sftp'

  class Tunnel
    #
    # Creates a Tunnel connection and execute custom commands
    #
    attr_accessor :hostname
    attr_accessor :user
    attr_accessor :password
    attr_accessor :port
    attr_reader :key_data
    attr_accessor :verbose
    attr_accessor :logger

    def initialize(config)
      #
      # configure connection based on Config provided
      #
      @hostname = config[:hostname]
      @user     = config[:username]
      @port     = config[:port]
      @verbose  = config[:verbose] || :info
      @password = config[:password]

      puts "Using config: #{config.inspect}"

      raise Exception, "Hostname should be provided" if @hostname.nil?
      raise Exception, "User should be provided" if @user.nil?

      if config[:key_data]
        key_data_file = File.expand_path(config[:key_data])
        raise "Key Data not found: #{key_data_file}" unless File.exist? key_data_file
        puts "Connecting #{@user}@#{@hostname}:#{@port} using Key Data: #{key_data_file}"
        @key_data = File.read(key_data_file)
      end

    end

    def on_shh
      if @key_data
        Net::SSH.start(@hostname, @user, :port => @port, :key_data => @key_data, :verbose => (@verbose)) do |session|
          @logger = session.logger
          yield session
        end
      else
        Net::SSH.start(@hostname, @user, :port => @port, :password => @password, :verbose => (@verbose)) do |session|
          @logger = session.logger
          yield session
        end
      end
    end
  end
end