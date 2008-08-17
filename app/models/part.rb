class Part < ActiveRecord::Base
  belongs_to :rip
  has_and_belongs_to_many :users
  
  validates_length_of :mrokhash, :is => 24
  validates_uniqueness_of :mrokhash
    
  def to_xml_with_all(options = {})
    options[:except] = [:id, :rip_id]
    to_xml_without_all(options)
  end
  alias_method_chain :to_xml, :all
    
  def duration_in_minutes
    (duration.blank?) ? '' : duration / 60
  end
  
  def audio_channels_in_words
    case audio_channels
    when 1 then 'mono'
    when 2 then 'stereo'
    else audio_channels
    end
  end
  
  def video_frame_rate_in_words
    (video_frame_rate.blank?) ? '' : "#{video_frame_rate} fps"
  end
  
  def audio_bit_rate_in_words
    (audio_bit_rate.blank?) ? '' : "#{audio_bit_rate/1000} kbps"
  end
  
  def audio_sample_rate_in_words
    (audio_sample_rate.blank?) ? '' : "#{audio_sample_rate/1000} kHz"
  end
  
  def real_movie_file?
    not container.blank?
  end
  
end
