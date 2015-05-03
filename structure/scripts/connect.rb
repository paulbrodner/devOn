#
# Connection example script
#
module Install
  include DevOn

  if is_os OS_WIN
    Command.run_shell("echo 'aaaa'")
  else
    Command.upload_file(use_file($config, "sample.txt.erb"), "/tmp/sample.txt")
    Command.run_shell("ls -la")
  end

  provision_on $config
end

