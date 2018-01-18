# DevOn [![Build Status](https://travis-ci.org/paulbrodner/devOn.svg?branch=master)](https://travis-ci.org/paulbrodner/devOn)
Throw some pixie dust on test environments !

```

  ██████╗ ███████╗██╗   ██╗ ██████╗ ███╗   ██╗
  ██╔══██╗██╔════╝██║   ██║██╔═══██╗████╗  ██║
  ██║  ██║█████╗  ██║   ██║██║   ██║██╔██╗ ██║
  ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██║╚██╗██║
  ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║ ╚████║
  ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝  ╚═══╝
                                  by Paul Brodner
```                                                                                     

## Features

* run shell script(s) or commands over multiple environments via SSH
* ability to provision remote/local unix machines (virtual boxes, AWS servers, etc.) based on one YAML configuration file (username/password or private key)
* ability to run any script with any configuration (script parameters) over remote machine
* ability to run scripts on your terminal (via Rake tasks) or from your web browser
* no agents required to be installed on remote machines, only ssh connection enabled
* usefull for provisioning test machines
* use 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devOn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devOn

## Usage

* Just require DevOn in your new module, add configuration settings based on [confstruct](https://github.com/mbklein/confstruct) gem
```ruby
require 'devOn'

module Install
  include DevOn
    Config.on "vagrant_machine" do
    connection do
      hostname "127.0.0.1"
      user "vagrant"
      port 2200
      key_data ".vagrant/machines/default/virtualbox/private_key"
    end
  end
  #
  # Properties that can be used in [ERB](http://en.wikipedia.org/wiki/ERuby) templates or shell scripts
  #
  Config.on "projectA" do
    tmp "/tmp"
  end

  # you can add more configuration on projectA, running shells from file
  # from command line, or upload files
  Command.run_shell_file(Config.projectA, "install/test.sh")
  Command.run_shell(Config.projectA, "ls -la /tmp")
  Command.run_shell(Config.projectA, "rm -rf /tmp/fromFile")
  Command.run_shell(Config.projectA, "ls -la /tmp")
  
  Command.upload_file(Config.projectA, "<source>/example.erb.rb", "/home/vagrant/test.rb")
  
  use_file(config, "custom-cache-context.xml") #will automaticaly ling "configs/projectA/custom-cache-context.xml" file
  
  provision_on($config)
end
```
The following line will actually run the provisioning remotely on the vm
```ruby
 provision_on($config)
```
A new generator is now available. After gem install, just run:
```
devon -n <name-of-your-project>
```
(this will create the structure of your new <name-of-your-project>)

## GUI Usage
There is also an interactive way to view and run existing scripts created with [devON](https://github.com/paulbrodner/devOn).
### Index
![index](http://s12.postimg.org/ovddnf1yl/image.png) 

### Execute
![execute](http://s2.postimg.org/chw02e2w9/image.png)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/devOn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
