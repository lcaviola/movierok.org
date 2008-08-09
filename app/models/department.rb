class Department < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  
  validates_presence_of :movie_id, :person_id, :role
  
  def to_xml_with_all(options = {})
    options[:include] = [ :person ]
    options[:except] = [ :person_id, :movie_id, :id]
    to_xml_without_all(options)
  end
  alias_method_chain :to_xml, :all

end
