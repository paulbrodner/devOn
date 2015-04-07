require "devOn/version"
require "awesome_print"
require "devOn/command"
require "devOn/config"
require "devOn/template"
require "devOn/tunnel"

module DevOn
  def self.print(info)
    ap info, options = {:indent=>4, :multiline=>true,
      :color => {
      :args       => :pale,
      :array      => :white,
      :bigdecimal => :blue,
      :class      => :yellow,
      :date       => :greenish,
      :falseclass => :red,
      :fixnum     => :blue,
      :float      => :blue,
      :hash       => :pale,
      :keyword    => :cyan,
      :method     => :purpleish,
      :nilclass   => :red,
      :rational   => :blue,
      :string     => :yellowish,
      :struct     => :pale,
      :symbol     => :cyanish,
      :time       => :greenish,
      :trueclass  => :green,
      :variable   => :cyanish
      }
    }
  end

  def self.included(base)
    require "devOn/provision"
    base.extend Provision
  end
end
