# DevOn
Throw some pixie dust on test environments !

```
DDDDDDDDDDDDD                                                        OOOOOOOOO
D::::::::::::DDD                                                   OO:::::::::OO
D:::::::::::::::DD                                               OO:::::::::::::OO
DDD:::::DDDDD:::::D                                             O:::::::OOO:::::::O
  D:::::D    D:::::D     eeeeeeeeeeee  vvvvvvv           vvvvvvvO::::::O   O::::::Onnnn  nnnnnnnn
  D:::::D     D:::::D  ee::::::::::::ee v:::::v         v:::::v O:::::O     O:::::On:::nn::::::::nn
  D:::::D     D:::::D e::::::eeeee:::::eev:::::v       v:::::v  O:::::O     O:::::On::::::::::::::nn
  D:::::D     D:::::De::::::e     e:::::e v:::::v     v:::::v   O:::::O     O:::::Onn:::::::::::::::n
  D:::::D     D:::::De:::::::eeeee::::::e  v:::::v   v:::::v    O:::::O     O:::::O  n:::::nnnn:::::n
  D:::::D     D:::::De:::::::::::::::::e    v:::::v v:::::v     O:::::O     O:::::O  n::::n    n::::n
  D:::::D     D:::::De::::::eeeeeeeeeee      v:::::v:::::v      O:::::O     O:::::O  n::::n    n::::n
  D:::::D    D:::::D e:::::::e                v:::::::::v       O::::::O   O::::::O  n::::n    n::::n
DDD:::::DDDDD:::::D  e::::::::e                v:::::::v        O:::::::OOO:::::::O  n::::n    n::::n
D:::::::::::::::DD    e::::::::eeeeeeee         v:::::v          OO:::::::::::::OO   n::::n    n::::n
D::::::::::::DDD       ee:::::::::::::e          v:::v             OO:::::::::OO     n::::n    n::::n
DDDDDDDDDDDDD            eeeeeeeeeeeeee           vvv                OOOOOOOOO       nnnnnn    nnnnnn

                                                                                     (c) Paul Brodner
```                                                                                     
This gem will help you configure test environments: Vagrant files, Remote VMs, AWS servers, etc,  based on configuration/connection provided (currenty user/password and private_key files are supported). More to come...

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

* Just require include DevOn in your new module, add configuration settings based on [confstruct](https://github.com/mbklein/confstruct) gem
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
end
```
And provisioning (running the Commands defined above) remotely on the vm with:
```ruby
 provision_on(Config.projectA)
```
* Update: a new generator is now available. After gem install, just run:
```
devon -n <name-of-your-project>
```
(this will create the structure and copy the files needed for this script to run)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/devOn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
