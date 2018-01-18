# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devOn/version'

Gem::Specification.new do |spec|
  spec.name          = "devOn"
  spec.version       = DevOn::VERSION
  spec.authors       = ["Paul Brodner"]
  spec.email         = ["paul.brodner@gmail.com"]
  
  spec.summary       = %q{Throw some pixie dust on test environments}
  spec.description   = %q{Configure virtual machines from local computer or remote hosts based on Ruby scripts, via SSH}
  spec.homepage      = "https://github.com/paulbrodner/devon"

  spec.files         = Dir['lib/**/*.*'] +  Dir['README*', 'LICENSE*', 'CODE_OF*'] +   Dir['structure/**/*']
  spec.bindir        = "bin"
  spec.executables   = "devon"
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_dependency "rake", "~> 10.0"
  spec.add_dependency 'confstruct', '~> 1.0.1'
  spec.add_dependency 'net-ssh' , '~> 4.2'
  spec.add_dependency 'net-sftp', '~> 2.1.2'
  spec.add_dependency 'awesome_print', '~> 1.6.1'
  spec.add_dependency 'sinatra', '~> 1.4.6'
  spec.add_dependency 'sinatra-param', '~> 1.4.0'
  spec.add_dependency 'activerecord', '~> 4.2.1'
  spec.add_dependency 'activesupport', '~>4.2.1'
  spec.add_dependency 'activemodel', '~>4.2.1'
  spec.add_dependency 'sqlite3', '~> 1.3.10'
  spec.add_dependency 'will_paginate', '~> 3.0.7'
  spec.add_dependency 'will_paginate-bootstrap', '~> 1.0.1'  
  spec.required_ruby_version = '>= 2.0.0'

  spec.post_install_message = <<msg
-------------------------------------------------
Thank you for installing devOn!

██████╗ ███████╗██╗   ██╗ ██████╗ ███╗   ██╗
██╔══██╗██╔════╝██║   ██║██╔═══██╗████╗  ██║
██║  ██║█████╗  ██║   ██║██║   ██║██╔██╗ ██║
██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██║╚██╗██║
██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║ ╚████║
╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝  ╚═══╝
                                by Paul Brodner
Enjoy!
-------------------------------------------------
msg
end
