#
# Connection example script
#
module Install
  include DevOn

  if is_os OS_WIN
    Command.run_shell("echo 'from WIN OS'")
  else
    # Command.upload_file(use_file($config, "sample.txt.erb"), "/tmp/sample.txt")
    Command.run_shell("echo 'from UNIX OS' && ls -la")
  end

  provision_on $config #this is the place where all commands above are executed.
end

