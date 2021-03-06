require 'rubygems'
gem 'activerecord'
require 'active_record'
require "stringex"
# Reload adapters to make sure ActsAsUrl sees the ORM
Stringex::ActsAsUrl::Adapter.load_available

puts "-------------------------------------------------"
puts "Running ActsAsUrl tests with ActiveRecord adapter"
puts "-------------------------------------------------"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "acts_as_url.sqlite3")

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :documents, :force => true do |t|
    t.string :title, :other, :url
  end

  # create_table :permuments, :force => true do |t|
  #   t.string :title, :permalink
  # end
end
ActiveRecord::Migration.verbose = true

class Document < ActiveRecord::Base
  acts_as_url :title
end

# class Updatument < ActiveRecord::Base
#   acts_as_url :title, :sync_url => true
# end

# class Mocument < ActiveRecord::Base
#   acts_as_url :title, :scope => :other, :sync_url => true
# end

# class Permument < ActiveRecord::Base
#   acts_as_url :title, :url_attribute => :permalink
# end

# class Procument < ActiveRecord::Base
#   acts_as_url :non_attribute_method

#   def non_attribute_method
#     "#{title} got massaged"
#   end
# end

# class Blankument < ActiveRecord::Base
#   acts_as_url :title, :only_when_blank => true
# end

# class Duplicatument < ActiveRecord::Base
#   acts_as_url :title, :duplicate_count_separator => "---"
# end

# class Validatument < ActiveRecord::Base
#   acts_as_url :title, :sync_url => true
#   validates_presence_of :title
# end

# class Ununiqument < ActiveRecord::Base
#   acts_as_url :title, :allow_duplicates => true
# end

# class Limitument < ActiveRecord::Base
#   acts_as_url :title, :limit => 13
# end

# class Skipument < ActiveRecord::Base
#   acts_as_url :title, :exclude => ["_So_Fucking_Special"]
# end

module AdapterSpecificTestBehaviors
  def setup
    # No setup tasks at present
  end

  def teardown
    Document.delete_all
    # Reset behavior to default
    Document.class_eval do
      acts_as_url :title
    end
  end

  def add_validation_on_document_title
    Document.class_eval do
      validates_presence_of :title
    end
  end

  def remove_validation_on_document_title
    Document.class_eval do
      _validators.delete :title
    end
  end
end
