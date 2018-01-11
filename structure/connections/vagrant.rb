module Vagrant
  include DevOn

  Config.on "vagrant" do
    os OS_UNIX

    settings do
      hostname  ENV['hostname']
      username  ENV['username']      
      password  ENV['password']
      port      ENV['port']
      # you can also use the private key, rathen than password
      # run `vagrant ssh-config` to find the path of key_data and add it as:      
      # key_data "connections/vagrant/.vagrant/machines/default/virtualbox/private_key"
    end

    tcp do
      host Config.vagrant.settings.hostname #notice that we can reuse values inside this ruby file
    end

    tmp "/tmp"
  end
end
