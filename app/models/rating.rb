class Rating < ActiveRecord::Base
  
  belongs_to :rip
  belongs_to :user
  
  before_validation :set_type_id
  validates_uniqueness_of :user_id, :scope => [:type_id, :rip_id]
  validates_presence_of :user_id, :rip_id, :rating, :type_id
  validates_inclusion_of :rating, :min => 1, :in => 1..3
 
  attr_accessor :type 
  
  def set_type_id
    self.type_id = $ratings.index(type) + 1 unless type.blank?
  end
  
end
