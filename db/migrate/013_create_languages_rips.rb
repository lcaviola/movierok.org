class CreateLanguagesRips < ActiveRecord::Migration
  def self.up
    create_table :languages_rips, :id => false, :force => true do |t|
      t.integer :language_id, :rip_id, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :languages_rips
  end
end
