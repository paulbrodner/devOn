# Alfresco Scripts

Alfresco Related Scripts.

## configs

Contains configuration files (let's say differed variables, files, shell commands, available 
in a structure logical order.
Each "scripts" can be executed using a specific configuration over one active connection.
Each configuration, will be compatible with one or more scripts. (don't define add_compatibility! and the config file will be available for all scripts)

```ruby
Config.<config_name>.add_compatibility!("<script_name1")
Config.<config_name>.add_compatibility!("<script_name2")
```

## connections

Contains connection related settings for VMs, Remote machines, amazon instances, rackspace, etc.
You can define sensitive information (password, tokens, into env.yml file).
(add new section in env.yml file using the same name of the configuration file: i.e. vagrant.rb connection will have a 'vagrant' section in env.yml file)

## scripts  
Are the actual scripts that will be executed over an active connection with a default configuration file.

## global variables

$config 	- is the current configuration ("configs") file active
$connection - is the current connection ("connections") file active
(This can be used in 'configs' or 'scripts')

## Usage

Clone the repository

```ruby
git clone https://github.com/paulbrodner/devOn
```

Modify configuration/scripts files as you wish and run rake helper commands

```ruby
rake -T # for a list of available tasks
```

## Useful Tools

FreeSSHD http://www.freesshd.com/?ctt=download

## Contributing

1. Fork it ( https://github.com/[my-github-username]/alfresco-scripts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request