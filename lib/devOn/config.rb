module DevOn
  require 'confstruct'

    # This is a wrapper class of http://www.rubydoc.info/gems/confstruct/1.0.1 gem
    # Usage: create a file with this code (more on the rubydoc above)
    # -----------------------------------
    #   Configs.on "project" do
    #     property1 "1"
    #     property2 do
    #      test "test12"
    #     end
    #     property3 "3"
    #   end
    #
    #   Configs.project.property2.test => will display 'test12'   
    # 
  module Config        
    extend self

    def on(name, &block)
      class_variable_set "@@#{name}", Confstruct::Configuration.new

      self.class.instance_eval do
        define_method "#{name}" do
          class_variable_get "@@#{name}"
        end
      end

      # if we have some configuration files then add those into an array
      if File.exist?("configs/#{name}")
        t = class_variable_get "@@#{name}"
        t.files = Dir["configs/#{name}/**/*.*"]
      end
      class_variable_get("@@#{name}").instance_exec(&block)
      self.send("#{name}").name = name
      self.send("#{name}")
    rescue NoMethodError => e
      raise "It seems that your configuration [#{name}.rb] is missing or has an uninitialized key: " + e.to_s
    end
  end
end