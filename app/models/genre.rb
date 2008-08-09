class Genre < ActiveRecord::Base
  has_and_belongs_to_many :movies
  
  validates_presence_of :omdb, :name
  validates_uniqueness_of :omdb
  validates_numericality_of :omdb
  
  def to_xml_with_all(options = {})
    options[:except] = [ :movie_id, :genre_id, :id ]
    to_xml_without_all(options)
  end
  alias_method_chain :to_xml, :all
  
end