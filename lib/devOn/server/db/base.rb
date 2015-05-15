require 'active_record'

module DevOn
  module Server
    module DB

      def self.open(database)
        ActiveRecord::Base.establish_connection(
            :adapter => "sqlite3",
            :database => database
        )
      end

      def self.open_connection!
        self.open File.expand_path("~/alfresco-scripts.db")
      end

      def self.setup
        ActiveRecord::Schema.define do
          create_table :histories do |table|
            table.column :script, :string
            table.column :configuration, :string
            table.column :connection, :string
            table.column :results, :string
            table.timestamps null: false
          end

        end
      end

      def self.insert_dummy_data
        require_relative "history"
        History.create(:script => "a/b3.rb", :configuration => "config1", :connection => "conn1", :results => "ok");
        History.create(:script => "a/b2.rb", :configuration => "config1", :connection => "conn1", :results => "ok");
      end

      #
      # open connection
      #
      self.open_connection!
    end
  end
end


