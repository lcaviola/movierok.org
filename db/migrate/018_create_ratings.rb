class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :rip_id, :user_id, :rating, :type_id, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
