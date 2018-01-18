require 'minitest/autorun'
require 'devOn'

class DevOnTest < Minitest::Test 

  def test_devOn_Config_imbricate_settings    
    config = DevOn::Config.on "myTestFile" do 
      property1 "1"
      property2 do
        name "property2-name"
      end
      property3 DevOn::Config.myTestFile.property2.name
    end
    assert_instance_of Confstruct::Configuration, config
    assert_equal "myTestFile", config.name
    assert_instance_of Confstruct::HashWithStructAccess, config.property2
    
    assert_equal config.property1, "1"
    assert_equal config.property2.name, "property2-name"
    assert_equal config.property3, "property2-name"        
  end

  def test_devOn_Config_files_are_empty_if_config_folder_doesnt_exist
    DevOn::Config.on "myConfigs" do;end    
    assert_nil DevOn::Config.myConfigs.files
  end

  def test_devOn_Config_files_are_NOT_empty_if_config_folder_exist
    require 'fileutils'
    FileUtils.mkdir_p 'configs/newConfigs' 
    File.open('configs/newConfigs/f1.txt', 'w+') { |file| file.write("f1 content") }
    File.open('configs/newConfigs/f2.txt', 'w+') { |file| file.write("f2 content") }

    DevOn::Config.on "newConfigs" do;end    
    assert_equal ['configs/newConfigs/f1.txt', 'configs/newConfigs/f2.txt'], DevOn::Config.newConfigs.files
  ensure
    FileUtils.rm_r 'configs'
  end
end