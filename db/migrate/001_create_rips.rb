class CreateRips < ActiveRecord::Migration
  def self.up
    create_table :rips do |t|
      t.integer :movie_id, :editor_id, :null => false
      t.integer :type_id, :version
      t.string  :releaser
      t.date    :released_at, :default => nil
      t.text    :release_comment
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :rips
  end
end
