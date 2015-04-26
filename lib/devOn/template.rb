require 'erb'

module DevOn
  module Template
    require 'tempfile'

    def self.from_string(string)
      ERB.new(string).result(binding)
    end

    def self.from_file(file)
      raise "Template file: #{File.expand_path(file)} was not found" unless File.exist?(file)
      ERB.new(File.read(file)).result(binding)
    end

    # return a temporary file created using the template
    def self.tmp_file(file)
      f = File.open(File.join(Dir.tmpdir(), File.basename(file)), "w")
      f.write(Template.from_file(file))
      f.close
      return f
    end
  end
end