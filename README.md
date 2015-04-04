# DevOn
Throw some pixie dust on test environments !
This gem will help you configure test environments: Vagrant files, Remote VMS, real servers based on configuration provided. More to come...

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

Just require include DevOn in your new module, add configuration settings based on [confstruct](https://github.com/mbklein/confstruct) gem
```ruby
require 'devOn'

module Install
  include DevOn
    #
    # at this time, only connection with user and keydata is available
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
end
```
And provisioning (running the Commands defined above) remotely on the vm with:
```ruby
 provision!(Config.vagrant_machine.connection, Config.projectA)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/devOn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
