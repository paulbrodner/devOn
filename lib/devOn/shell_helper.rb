module DevOn
  module ShellHelper
    #
    # Helper injected in DevOn module
    #
    def run_shell_file(config, shell_file)
      puts "Using shell file: #{shell_file}"
      config.add_shells! shell_file
    end
  end
end