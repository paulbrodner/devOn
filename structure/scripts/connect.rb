#
# Example script that will connect to a particular connection found in "connections" folder
#
module Install
  include DevOn

  # paul: you can define custom scripts that will be executed based on the destination operating system
  if is_os OS_WIN
    Command.run_shell("echo 'from WIN OS'")
  else
    # Command.upload_file(use_file($config, "sample.txt.erb"), "/tmp/sample.txt")
    Command.run_shell("echo 'from UNIX OS' && ls -la")
  end

  provision_on $config #this is the place where all commands above are executed.
end

