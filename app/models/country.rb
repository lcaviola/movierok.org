class Country < ActiveRecord::Base
  has_and_belongs_to_many :movies
  
  def to_xml_with_all(options = {})
    options[:except] = [ :movie_id, :genre_id, :id ]
    to_xml_without_all(options)
  end
  alias_method_chain :to_xml, :all
  
  def self.find_all_by_frequency(o = {})
    o[:join_table] = 'countries_movies' unless o[:join_table]
    left = 'left' unless o[:only_used]
    find(:all, 
      :from => "countries #{left} join   
                  (select country_id, count(*) as country_count from #{o[:join_table]} group by country_id) as country_frequency
                  on (countries.id = country_frequency.country_id)",
      :order => 'country_frequency.country_count DESC, countries.id')
  end
  
end