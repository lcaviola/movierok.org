class Comment < ActiveRecord::Base
  belongs_to :rip
  belongs_to :user
  
  validates_presence_of :content, :rip, :user
  validates_length_of :content, :in => 10..200
  
end
