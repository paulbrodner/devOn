module Vagrant
  include DevOn

  Config.on "vagrant" do
    os OS_UNIX

    settings do
      hostname "127.0.0.1"
      username ENV['username']
      port ENV['port']
      # run vagrant ssh-config to find the path of key_data
      key_data "connections/vagrant/.vagrant/machines/default/virtualbox/private_key"
    end

    tcp do
      host Config.vagrant.settings.hostname
    end

    tmp "/tmp"
  end
end
