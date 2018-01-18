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

* run shell script(s)/commands over multiple environments via [SSH](https://en.wikipedia.org/wiki/Secure_Shell)
* ability to configure remote/local unix machines (virtual boxes, AWS servers, etc.) using simple Ruby [DSL](https://en.wikipedia.org/wiki/Domain-specific_language)
* ability to run any script with any configuration (script parameters) over remote machine
* compatible with [ERB](https://ruby-doc.org/stdlib-2.5.0/libdoc/erb/rdoc/ERB.html) templating
* ability to run scripts on your terminal (via Rake tasks) or from your web browser
* **agent-less**: no agents required  to be installed on remote machines, only ssh connection enabled
* usefull for configuring test machines

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
> Checkout the README.md file generated along with the project or take a look [here](structure/README.md).

## Running scripts from browser
There is also an interactive way to view and execute your scripts created with [devON](https://github.com/paulbrodner/devon).

#### Index (http://localhost:4567)

This page will list all available scripts, connections and configuration
![index](http://s12.postimg.org/ovddnf1yl/image.png) 

#### Execute (http://localhost:4567/execute)

This page will show the execute scripts with their output
![execute](http://s2.postimg.org/chw02e2w9/image.png)


## Contributing

### Experiment
After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

### Install from code
To install this gem onto your local machine, run `bundle exec rake install`.

### Run tests
I am using Ruby Minitest::Test
```ruby
$ rake test
```

1. Fork it ( https://github.com/paulbrodner/devon/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
