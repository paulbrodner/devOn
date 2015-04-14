module DevOn
  require 'yaml'
  require 'env'
  
  class EnvConfig
    def initialize(path)
      @path = path
    end

    def load(root)
      if @yml ||= load_yml
        @yml.each { |key, value| set_value(key, value) }
        @yml[root].each { |key, value| set_value(key, value) } if @yml[root]
      end
    end

    private

    def load_yml
      yml_path = File.expand_path(@path)
      return nil unless File.exists?(yml_path)
      YAML.load_file(yml_path)
    end

    def set_value(key, value)
      ENV[key.to_s] = value.to_s unless value.is_a?(Hash)
    end
  end
end
