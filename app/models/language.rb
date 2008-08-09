class Language < ActiveRecord::Base
  has_and_belongs_to_many :rips
  
  def self.find_all_by_frequency(o = {})
    o[:join_table] = 'languages_rips' unless o[:join_table]
    left = 'left' unless o[:only_used]
    find(:all, 
         :from => "languages #{left} join   
                  (select language_id, count(*) as lang_count from #{o[:join_table]} group by language_id) as lang_frequency
                  on (languages.id = lang_frequency.language_id)",
          :order => 'lang_frequency.lang_count DESC, languages.id',
          :conditions => 'iso_3166 IS NOT NULL')
  end
  
  def self.find_all_subtitles_by_frequency(o = {})
    o[:join_table] = 'rips_subtitles'
    self.find_all_by_frequency(o)
  end
  
end
