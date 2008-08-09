class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.integer   :omdb,  :null => false
      t.string    :title, :null => false
      t.text      :description
      t.integer   :year
      t.string    :image
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :movies
  end
end