class CreatePartsUsers < ActiveRecord::Migration
  def self.up
    create_table :parts_users, :id => false, :force => true do |t|
      t.integer :part_id, :user_id, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :parts_users
  end
end
