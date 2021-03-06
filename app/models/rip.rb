require 'acts_as_ferret'

class Rip < ActiveRecord::Base
  belongs_to :movie
  belongs_to :editor, :class_name => 'User'
  has_many :parts, :order => 'number'
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :subtitles, :class_name => 'Language', :join_table => 'rips_subtitles'
  has_many :ratings
  has_many :comments
  
  validates_presence_of :movie_id, :message => "is not valid or doesn't exist on OMDB"
  validates_presence_of :editor_id
  validate :validate_presence_of_parts, :validate_correctness_of_parts
  
  before_validation :associate_movie, :save_languages_and_subtitles, :prepare_parts
  before_save :save_parts
  after_save :update_indexes, :update_graphs
    
  acts_as_ferret :fields => {
    :title => {:store => :yes},
    :person => {:store => :yes},
    :releaser => {:store => :yes},
    :genre => {:store => :yes, :index => :untokenized},
    :country => {:store => :yes, :index => :untokenized},
    :user => {:store => :yes, :index => :untokenized},
    :lang => {:store => :yes, :index => :untokenized},
    :sub => {:store => :yes, :index => :untokenized},
    :type => {:store => :yes, :index => :untokenized}
  }
  acts_as_versioned
  
  attr_accessor :omdb, :mrokhashes, :part_files, :language_ids, :subtitle_ids, :changed_association

 
  def omdb
    @omdb ||= (movie and @omdb.blank?) ? movie.omdb : @omdb
  end
  
  def video_rating
    calc_rating(:video)
  end
  
  def audio_rating
    calc_rating(:audio)
  end
    
  def users
    User.find(:all, :select => 'users.*, parts_users.updated_at', :joins => 'inner join parts_users on parts_users.user_id = users.id inner join parts on parts_users.part_id = parts.id inner join rips on parts.rip_id = rips.id', 
      :conditions => [ 'rips.id = ?', id], :group => 'users.id', :order => 'users.id DESC')
  end
  
  # for indexing and searching
  
  def person
    movie.departments.collect(&:person).collect do |p|
      p.name.replace_special_chars
    end
  end
  
  def title
    movie.title.replace_special_chars.downcase
  end
  
  def genre
    movie.genres.collect(&:name).collect(&:downcase)
  end
  
  def country
    movie.countries.collect(&:iso_3166)
  end
  
  def user
    users.collect(&:name)
  end
  
  def lang
    languages.collect(&:iso_639_1)
  end
  
  def sub
    subtitles.collect(&:iso_639_1)
  end
  
  def type
    type_as_text.downcase
  end
  
  def type_as_text
    $types[type_id - 1] if type_id
  end
  
  #
  def self.get(params = {}, options = {})
    user = params[:user] || params[:user_id]
    options[:page] = params[:page]
    options[:per_page] ||= 30
    
    search = (params[:search] || '*').clone.downcase.replace_some_special_chars
    search << " AND user:#{user}" if user

    sort = (params[:sort] and params[:sort] == 'title') ? :title : :id
    searchtype = (sort == :title) ? :string : :integer 
    reverse = !(params[:order] and params[:order] == 'down')
    options[:sort] = Ferret::Search::SortField.new(sort, :type => searchtype, :reverse => reverse)

    Rip.find_with_ferret(search, options)
  end

  def self.search(params, options)
  end
  
  def self.find_by_mrokhash(mrokhash)
    self.find(:all, :include => :parts, :conditions => ['parts.mrokhash IN (?)', mrokhash], :group => 'rips.id')
  end 
  
  def self.find_releasers_like(val)
    self.find(:all, :select => 'rips.releaser', :conditions => ['rips.releaser LIKE ?', "#{val}%" ])
  end
  
  def self.find_all_releasers(limit = nil)
    self.find(:all, :select => 'rips.releaser, count(*) as count', :conditions => 'rips.releaser IS NOT NULL AND rips.releaser != ""', :group => 'rips.releaser', :limit => limit, :order => 'count DESC').collect(&:releaser)
  end
  
  #
  
  def to_xml_with_all(options = {})
    options[:include] = [:parts, :movie]
    options[:except] = :movie_id
    to_xml_without_all(options)
  end
  alias_method_chain :to_xml, :all
  
  

  
  def to_param
    if self.movie and self.movie.title
      "#{id}-#{self.movie.title.downcase.gsub(/[^a-z0-9]+/i, '-')}"
    else
      id
    end
  end
  
  # wird aufgerufen beim saven wenn backup gemacht wird
  def version_associations(new_model)
    new_model.part_ids = parts.collect(&:id).join(';')
    new_model.language_ids = languages.collect(&:id).join(';')
    new_model.subtitle_ids = subtitles.collect(&:id).join(';')
  end
  
  def revert_to_with_associations!(version)
    res = revert_to_without_associations!(version)
    if res
      backup = versions.find_by_version(version)
      self.parts = Part.find_all_by_id(backup.part_ids.split(';'))
      self.languages = Language.find_all_by_id(backup.language_ids.split(';'))
      self.subtitles = Language.find_all_by_id(backup.subtitle_ids.split(';'))
    end
    res
  end
  alias_method_chain :revert_to!, :associations
  
  def changed_with_associations?
    return true if @changed_association
    c = changed_without_associations?
    if c and changed.length == 1 and self.editor_id_changed?
      return false
    end
    return c    
  end
  alias_method_chain :changed?, :associations
  
  def update_graphs
    rips_line_graph
    rips_pie_graph
  end
  
  def rips_line_graph
    counts = []
    points = []
    date = Rip.find(:last, :order => 'created_at DESC').created_at
    until date > Time.now
      points << date.strftime('%b')
      date += 1.month
      counts << Rip.count(:conditions => ['created_at <= ?', date])
    end

    graph = Scruffy::Graph.new
    graph.title = 'rip count on movierok'
    graph.renderer = Scruffy::Renderers::Standard.new
    graph.add :line, 'rips', counts
    graph.point_markers = points

    graph.render  :width => 600, :height => 200, :to => "public/rips_line_graph.png", :as => 'png'
  end
  
  def rips_pie_graph
    graph = Scruffy::Graph.new
    graph.renderer = Scruffy::Renderers::Pie.new
    graph.title = 'rip creators'
    items = Hash.new
    topcount = 0
    topusers = User.find_all_with_created_rips_count[0...5]
    for user in topusers
      topcount += user.created_rips_count
      items[user.name] = user.created_rips_count
    end
    items['others'] = Rip.count - topcount
    graph.add :pie, '', items
    graph.render  :width => 600, :height => 200, :to => "public/rips_pie_graph.png", :as => 'png'
  end

  #
  private
  
  def validate_presence_of_parts
    if @part_files.empty? and parts.empty?
      errors.add_to_base('you have to add at least one part')
    end
  end
  
  def validate_correctness_of_parts
    for part in @part_files
      errors.add_to_base("part belongs to another rip") if (not part.rip_id.nil? and part.rip_id != self.id)
      errors.add_to_base("some parts you've added couldn't be recognized as movies") unless part.real_movie_file?
    end
  end
  
  def prepare_parts
    @mrokhashes = [] unless @mrokhashes
    @part_files = Part.find_all_by_mrokhash(@mrokhashes)
    @mrokhashes.each_with_index do |mrokhash, i|
      part = @part_files.detect {|p| p.mrokhash == mrokhash}
      part.number = i
      part.save
    end
  end  
  
  def save_parts
    # WARNING: overwrites self.parts
    self.parts.replace(@part_files)
  end
  
  
  def save_languages_and_subtitles
    # WARNING: overwrites self.languages and self.subtitles
    @language_ids = [] unless @language_ids
    @language_ids = [@language_ids] unless @language_ids.instance_of? Array
    tmp_langs = Language.find_all_by_id(@language_ids)
    unless tmp_langs.has_same_content?(self.languages)
      self.languages.replace tmp_langs
      @changed_association = true
    end
    
    @subtitle_ids = [] unless @subtitle_ids
    @subtitle_ids = [@subtitle_ids] unless @subtitle_ids.instance_of? Array
    tmp_subs = Language.find_all_by_id(@subtitle_ids)
    unless tmp_subs.has_same_content?(self.subtitles)
      self.subtitles.replace tmp_subs
      @changed_association = true
    end
  end
  
  
  def associate_movie
    self.movie = Movie.get_from_omdb(omdb)
  end 
   
  def update_indexes  
    ferret_update
  end
  
  def calc_rating(type)
    type_id = $ratings.index(type) + 1
    #    ratings = self.ratings.find(:all, :select => 'rating', :conditions => ['type_id = ?', type_id])
    ratings = Rating.find(:all, :select => 'rating', :conditions => ['type_id = ? AND rip_id = ?', type_id, self.id])
    return 0 if ratings.length == 0
    Float(ratings.collect(&:rating).inject(&:+).to_i) / Float(ratings.length)
  end
  
  
end
