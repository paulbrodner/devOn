require 'minitest/autorun'
require 'devOn'

class DevOnTest < Minitest::Test
  
  def test_devOn_Structure
    list = %w{              
              config.ru
              configs
              configs/simple
              configs/simple/sample.txt.erb
              configs/simple.rb
              connections
              connections/env.yml
              connections/env.yml.example
              connections/vagrant
              connections/vagrant/Vagrantfile
              connections/vagrant.rb
              Gemfile
              LICENSE
              Rakefile
              README.md
              scripts
              scripts/connect.rb              
    }
    ap "Actual Structure:"
    Dir["structure/**/*"].each do |f|
      ap f
    end

    assert_equal list.count, Dir["structure/**/*"].count    
  end 

  def test_devOn_Structure_rake
    `cd structure && rake -T`
  end
end