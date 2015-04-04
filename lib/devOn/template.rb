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
      tmp = Tempfile.new(File.basename(file))
      tmp.write(Template.from_file(file))
      tmp.rewind
      puts "[TMP FILE] #{tmp.path}"
      return tmp
    end
  end
end