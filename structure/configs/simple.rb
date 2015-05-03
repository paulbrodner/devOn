module Simple
  include DevOn
  Config.on "simple" do
    shell "ls -la /vagrant"
  end
end
