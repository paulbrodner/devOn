module DevOn
  module Structure
    require 'fileutils'

    def self.setup(name)
      source = File.join(root_path,"structure")
      FileUtils.cp_r source, name
      #FileUtils.mv "structure", name
      puts "Structure [#{name}] created ! Now run rake commands for more info!"
    end

    def self.root_path
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
  end
end
