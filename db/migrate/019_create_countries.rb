class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name, :iso_3166
    end
    
    Country.create(:iso_3166 => 'us', :name => 'USA')
    Country.create(:iso_3166 => 'gb', :name => 'England')
    Country.create(:iso_3166 => 'fr', :name => 'France')
    Country.create(:iso_3166 => 'de', :name => 'Germany')
    Country.create(:iso_3166 => 'ie', :name => 'Ireland')
    Country.create(:iso_3166 => 'ch', :name => 'Switzerland')
    Country.create(:iso_3166 => 'it', :name => 'Italy')
    Country.create(:iso_3166 => 'dk', :name => 'Denmark')
    Country.create(:iso_3166 => 'jp', :name => 'Japan')
    Country.create(:iso_3166 => 'se', :name => 'Sweden')
    Country.create(:iso_3166 => 'es', :name => 'Spain')
    Country.create(:iso_3166 => 'cn', :name => 'China')
    Country.create(:iso_3166 => 'hk', :name => 'Hong Kong')
    Country.create(:iso_3166 => 'ru', :name => 'Russia')
    Country.create(:iso_3166 => 'bg', :name => 'Bulgaria')
    Country.create(:iso_3166 => 'cz', :name => 'Czech Republic')
    Country.create(:iso_3166 => 'gr', :name => 'Greece')
    Country.create(:iso_3166 => 'fi', :name => 'Finland')
    Country.create(:iso_3166 => 'hr', :name => 'Croatia')
    Country.create(:iso_3166 => 'hu', :name => 'Hungary')
    Country.create(:iso_3166 => 'kr', :name => 'Korea')
    Country.create(:iso_3166 => 'nl', :name => 'Netherlands')
    Country.create(:iso_3166 => 'no', :name => 'Norway')
    Country.create(:iso_3166 => 'pl', :name => 'Poland')
    Country.create(:iso_3166 => 'pt', :name => 'Portugal')
    Country.create(:iso_3166 => 'ro', :name => 'Romania')
    Country.create(:iso_3166 => 'sk', :name => 'Slovakia')
    Country.create(:iso_3166 => 'si', :name => 'Slovenia')
    Country.create(:iso_3166 => 'rs', :name => 'Serbian')
    Country.create(:iso_3166 => 'tr', :name => 'Turkey')
    Country.create(:iso_3166 => 'ua', :name => 'Ukraine')
    Country.create(:iso_3166 => 'vn', :name => 'Vietnam')
    Country.create(:iso_3166 => 'al', :name => 'Albania')
    Country.create(:iso_3166 => 'ca', :name => 'Canada')
    Country.create(:iso_3166 => 'be', :name => 'Belgium')
    Country.create(:iso_3166 => 'br', :name => 'Brazil')
    Country.create(:iso_3166 => 'il', :name => 'Israel')
    Country.create(:iso_3166 => 'id', :name => 'Indonesia')
    Country.create(:iso_3166 => 'in', :name => 'India')
    Country.create(:iso_3166 => 'ba', :name => 'Bosnia and Herzegovina')
    Country.create(:iso_3166 => 'za', :name => 'South Africa')
    
  end
  
  def self.down
    drop_table :countries
  end
end
