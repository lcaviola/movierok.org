class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.integer :role, :movie_id, :person_id, :null => false
      t.integer :number, :default => 0
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :departments
  end
end