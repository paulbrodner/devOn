require 'minitest/autorun'
require 'devOn'

class DevOnTest < Minitest::Test
  def test_devOn_Commands    
    assert_equal true, DevOn::Command.method_defined?(:to_h)
    
    assert_includes DevOn::Command.singleton_methods, :add, :backup
    assert_includes DevOn::Command.singleton_methods, :download_file, :upload_file
    assert_includes DevOn::Command.singleton_methods, :run_shell_file, :run_shell
    assert_includes DevOn::Command.singleton_methods, :apply_template, :ask_permision
    assert_includes DevOn::Command.singleton_methods, :kill_program, :yaml_tag
    assert_equal DevOn::Command.singleton_methods.count, 10
  end 
end