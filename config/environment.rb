# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')


Rails::Initializer.run do |config|

  config.action_controller.session = { 
    :session_key => '_movierok.org_session_id', 
    :secret => 'sd80ag7s89adg76s8adg6sdgjsadgjsad-husad7hsadhsadhh12481249812grf9g12f6tasf7awf',
    :session_expires => Time.local(2009,'jan')  } 

  config.load_paths += %W(#{RAILS_ROOT}/vendor/plugins/acts_as_versioned/lib)
  config.load_paths += %W(#{RAILS_ROOT}/app/sweepers)
  
  #config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"
  
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end


ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => '%b %d %Y'
)
  
# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile


##UPDATE FROM OMDB
#movies = Movie.find(:all, :order => :updated_at, :limit => 100)
#movies.each do |m| 
#  m.update_from_omdb
#  m.rips.each(&:ferret_update) #totest
#end


    
class String
  def escape_single_quotes
    self.gsub(/[']/, '\\\\\'')
  end
  
  def replace_special_chars
    self.gsub(/ü/, 'u').gsub(/ä/, 'a').gsub(/ö/, 'o').gsub(/[^a-zA-Z0-9:' \-_]+/, '')
  end
  
  def replace_some_special_chars
    self.gsub(/ü/, 'u').gsub(/ä/, 'a').gsub(/ö/, 'o').gsub(/[^a-zA-Z0-9:' \*\|\-\+\~\(\)"_]+/, '')
  end
end

module Enumerable
  # checks if this array contains the same elements despite their order
  def has_same_content?(obj)
    return false unless obj.length == self.length
    for e in obj
      return false unless self.include? e
    end
    return true
  end
end


$roles = ['actor', 'director', 'author', 'composer', 'producer']
$genres = {
  'Action'          => 28,
  'Adventure'       => 12,
  'Animation'       => 16,
  'Comedy'          =>35,
  'Crime'           =>80,
  'Disaster'        =>105,
  'Documentary'     =>99,
  'Drama'           => 18,
  'Eastern'         => 82,
  'Erotic'          => 2916,
  'Fantasy'         =>14,
  'Historical'      => 36,
  'Horror'          =>27,
  'Musical'         => 22,
  'Road-Movie'      =>1115,
  'Science-Fiction' => 878,
  'Thriller'        =>53,
  'Western'         => 37 
}
$types = ['DVD-Rip', 'Cam-Rip', 'Telesync', 'Screener', 'R5', 'Telecine', 'Workprint']
$ratings = [:video, :audio, :movie]

# don't forget to remove the cache when changing this
$compatible_ff_ext_versions = ['0.1.9', '0.2', '0.2.1']
