class CreateGenresMovies < ActiveRecord::Migration
  def self.up
    create_table :genres_movies, :id => false, :force => true do |t|
      t.integer :genre_id, :movie_id, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :genres_movies
  end
end