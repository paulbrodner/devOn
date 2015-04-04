require 'erb'

module DevOn
  module Template
    def self.from_string(string)
      ERB.new(string).result(binding)
    end

    def self.from_file(file)
      raise "Template file: #{File.expand_path(file)} was not found" unless File.exist?(file)
      ERB.new(File.read(file)).result(binding)
    end

    module Helper
      #
      # Helper injected in DevOn module
      #
      def apply_template(config, template, destination)
        puts "Using template: #{template} for #{destination}"

        config.add_templates!({
          :file=> Template.from_file(template),
          :destination=>destination}
        )
      end
    end
  end
end