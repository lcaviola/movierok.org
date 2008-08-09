class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.integer :omdb, :null => false
      t.string :name, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :people
  end
end