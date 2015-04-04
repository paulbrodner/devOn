module DevOn
  require 'confstruct'
  module Config
    #
    # This is a wrapper class of confstruct gem
    # Configs.on "project" do
    #   property1 "1"
    #   property2 do
    #     test "test12"
    #   end
    #   property3 "3"
    # end
    # Configs.project.property2.test => will display 'test12'
    #    
    extend self
    
    def on(name, &block)
      class_variable_set "@@#{name}", Confstruct::Configuration.new
      self.class.instance_eval do
        define_method "#{name}" do
          class_variable_get "@@#{name}"
        end
      end
      class_variable_get("@@#{name}").instance_exec(&block)
      self.send("#{name}")
    end
  end
end