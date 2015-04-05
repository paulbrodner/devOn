require "devOn/version"
require "awesome_print"
require "devOn/command"
require "devOn/config"
require "devOn/template"
require "devOn/tunnel"

module DevOn
  def self.included(base)
    require "devOn/provision"
    base.extend Provision
  end 
end
