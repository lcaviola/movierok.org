class Person < ActiveRecord::Base
  has_many :departments
  
  validates_presence_of :omdb, :name
  
end
