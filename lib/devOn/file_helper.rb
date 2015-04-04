module DevOn
  module FileHelper
    #
    # Helper injected in DevOn module
    #
    def upload_file(config, file)
      puts "Using file for upload: #{file}"
      config.add_files! file
    end
  end
end