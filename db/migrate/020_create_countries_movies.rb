class CreateCountriesMovies < ActiveRecord::Migration
  def self.up
    create_table :countries_movies, :id => false, :force => true do |t|
      t.integer :country_id, :movie_id, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :countries_movies
  end
end