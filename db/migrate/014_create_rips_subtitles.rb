class CreateRipsSubtitles < ActiveRecord::Migration
  def self.up
    create_table :rips_subtitles, :id => false, :force => true do |t|
      t.integer :language_id, :rip_id, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :rips_subtitles
  end
end
