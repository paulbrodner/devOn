module DevOn
  require 'yaml'
  
  # Set in ruby ENV all imbricated key/value pairs from YAML files
  #
  class EnvConfig
    def initialize(path)
      @path = path
    end

    # Load all child key/value pairs under <root> element passed
    # Having the example bellow, load('vagrant') will load key/values only from that YAML element
    # -----
    # defaults: &defaults  
    #   hostname: 127.0.0.1  
    #   port: 22      
    # vagrant:
    #   <<: *defaults
    #   username: vagrant
    #   password: vagrant
    #   port: 2222
    # -----
    def load(root)
      if @yml ||= load_yml
        @yml.each { |key, value| set_value(key, value) }
        @yml[root].each { |key, value| set_value(key, value) } if @yml[root]
      end
    end

private

    # load and return the yaml file pased  
    def load_yml
      yml_path = File.expand_path(@path)
      return nil unless File.exists?(yml_path)
      YAML.load_file(yml_path)
    end

    # update the YAML <key> with <value>
    def set_value(key, value)
      ENV[key.to_s] = value.to_s unless value.is_a?(Hash)
    end
  end
end
