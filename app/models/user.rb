require 'digest/sha1'

class User < ActiveRecord::Base
  has_and_belongs_to_many :parts
  
  has_many :ratings
  has_many :comments
  
  validates_presence_of :name
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^\w+$/
  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix, :allow_blank => true

  
  def unknown_parts
    parts.find(:all, :conditions => {:rip_id => nil})
  end
  
  def has_rip?(rip)
    parts.include? rip.parts.first
  end
  
  def password
    @password
  end
  
  def password=(pwd)
    unless pwd.blank?
      @password = pwd
      create_new_salt
      self.hashed_password = User.encrypted_password(self.password, self.salt)
    end
  end
    
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def to_param
    self.name
  end
  
  def created_rips_in_percent(total_rips = Rip.count)
    return 0 unless total_rips > 0
    ((Float(self.created_rips_count) / (Float(total_rips) / 100.0) * 10.0).round / 10.0)
  end
  
  def created_rips_count
    ActiveRecord::Base.connection.execute(
      "SELECT count(*) FROM rip_versions WHERE version = 1 AND editor_id = #{self.id}"
    ).fetch_row.first.to_i
  end

  def self.find_all_with_created_rips_count
    self.find(:all,
      :select => 'users.*, (SELECT count(*) FROM rip_versions WHERE version = 1 AND editor_id = users.id) as created_rips_count',
      :order => 'created_rips_count DESC, users.created_at')
  end
  
  def self.authenticate(name, pw)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(pw, user.salt)
      user = nil if user.hashed_password != expected_password
    end
    user
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + '_movierok_' + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  #  def self.find_names_like(val)
  #    self.find(:all, :select => 'users.name', :conditions => ['users.name LIKE ?', "#{val}%" ])
  #  end
  
end
