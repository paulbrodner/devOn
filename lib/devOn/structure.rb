module DevOn
  module Structure
    require 'fileutils'

    # create a new folder as <name> copying the entire folder "structure" from the root path
    def self.setup(name)
      source = File.join(root_path,"structure")
      FileUtils.cp_r source, name
      puts "Structure [#{name}] created ! Now run rake commands for more info!"
    end
    
    def self.root_path
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
  end
end
