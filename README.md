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

## DevON Features

* ability to configure remote/local unix machines (virtual boxes, AWS servers, etc.) using simple Ruby [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) via [SSH](https://en.wikipedia.org/wiki/Secure_Shell) protocol
* ability to run one script with any configuration (script parameters) over remote machine in interactive mode
* ability to run multiple scripts unattended
* compatible with [ERB](https://ruby-doc.org/stdlib-2.5.0/libdoc/erb/rdoc/ERB.html) templating
* ability to run scripts on your terminal (via Rake tasks) or from your web browser
* ability to keep track of all scripts executed in browser and the output result
* **agent-less**: no agents required  to be installed on remote machines, only ssh connection enabled
* https://en.wikipedia.org/wiki/SFTP
* ability to generate new project structure will all boilerplates in place 

## Installation

```ruby
$ gem install devon
```

## Usage
```ruby
$ devon -n <name-of-your-project>
```

This will generate a project structure will all configuration and scripts.

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `Guideline`
> Checkout the [README.md](structure/README.md) file generated along with the project.

## Playing with Virtual Machine (optional)
After generating your new project, you can test it on a Virtual Machine on your OS.
The `connections/vagrant` folder (in the generated project) contains one [Vagrantfile](https://www.vagrantup.com/docs/vagrantfile/) that will spin up a test virtual machine for you.

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `Prerequisites`
>You need to have [Vagrant](https://www.vagrantup.com/) installed on your machine and [VirtualBox](https://www.virtualbox.org/)

Open a new terminal and navigate to `connection/vagrant` and type:

```shell
$ vagrant up
```
This will download and configure for you in the background one Ubuntu test machine that you can use for further testing using the default script.

## Running scripts from browser
There is also an interactive way to view and execute your scripts created with [devON](https://github.com/paulbrodner/devon).

After generate your new project using [this](structure/README.md) guideline, run:

```ruby
$ rake server:up
```

This will spin-up one [Sinatra](http://sinatrarb.com/) based webserver locally:

#### Index (http://localhost:4567)

This page will list all available scripts, connections and configuration
![index](http://s12.postimg.org/ovddnf1yl/image.png) 

#### Execute (http://localhost:4567/execute)

This page will show the execute scripts with their output
![execute](http://s2.postimg.org/chw02e2w9/image.png)


## Contributing

1. Fork it ( https://github.com/paulbrodner/devon/fork )

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

Run `Mintest::Test` from the `test` folder with:
```ruby
$ rake test # you can also simply call 'rake'
```

2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
