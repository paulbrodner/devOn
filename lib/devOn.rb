require "devOn/version"
require "devOn/config"
require "devOn/template"
require "devOn/tunnel"

module DevOn
  
  def self.included(base)
    require "devOn/file_helper"
    require "devOn/shell_helper"
    require "devOn/provision"

    base.extend ShellHelper
    base.extend FileHelper
    base.extend Template::Helper
    base.extend Provision
  end
  
 
  
  
end
