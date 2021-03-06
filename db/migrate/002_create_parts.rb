class CreateParts < ActiveRecord::Migration
  def self.up
    create_table :parts do |t|
      t.integer   :rip_id
      t.string    :mrokhash, :null => false
      t.integer   :number, :default => 0
      
      t.integer    :audio_bit_rate, :audio_channels, :audio_sample_rate, :video_frame_rate, :duration, :filesize
      t.string     :audio_encoding, :video_encoding, :video_resolution, :md5, :sha1, :container
      t.boolean    :movie_file_meta_data, :default => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :parts
  end
end
