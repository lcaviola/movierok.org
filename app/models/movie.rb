class Movie < ActiveRecord::Base
  has_many :rips
  has_many :departments, :order => 'role, number'
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :countries
  
  validates_presence_of :omdb, :title
  validates_uniqueness_of :omdb
  validates_numericality_of :omdb
 
  def image_url(type = 'default')
    if image
      "http://www.omdb.org/image/#{type}/#{image}.jpeg"
    else
      "/images/no_cover_#{type}.png"
    end
  end
  
  def omdb_url
    "http://www.omdb.org/movie/#{omdb}"
  end
  
  def update_from_omdb
    Movie.get_from_omdb(self.omdb)
  end
  
  def to_xml_with_all(options = {})
    options[:include] = [:departments, :genres]
    options[:except] = [ :id ]
    to_xml_without_all(options)
  end
  alias_method_chain :to_xml, :all
  
  def method_missing_with_roles(m, *args, &block)
    # add dynamic methods (actors, directors, etc.)
    if $roles.include? m.to_s.singularize
      departments.select { |d| d.role == $roles.index(m.to_s.singularize) }.collect(&:person)
    else
      method_missing_without_roles(m, *args, &block)
    end
  end
  alias_method_chain :method_missing, :roles
  
  def self.get_from_omdb(omdb)
    url = "http://www.omdb.org/movie/#{omdb}/embed_data/"
    if ENV['http_proxy']
      proxy = URI.parse(ENV['http_proxy'])
      proxy_host, proxy_port, proxy_user, proxy_password = proxy.host, proxy.port, proxy.user, proxy.password
    end
    http = Net::HTTP::Proxy(proxy_host, proxy_port, proxy_user, proxy_password)
    xml_data = http.get_response(URI.parse(url)).body
   
    #    xml_data = File.open("/home/cal/Desktop/embed_data.xml").read
    doc = REXML::Document.new(xml_data)
    
    #movie
    movie = Movie.find_or_initialize_by_omdb omdb
    movie.title = doc.elements['movie/name'].text.chomp
    movie.description = doc.elements['movie/abstract'].text
    movie.year = doc.elements['movie/date'].text.to_i if doc.elements['movie/date']
    unless doc.elements['movie/image'].text['no_cover']
      movie.image = doc.elements['movie/image'].text[/\d+/].to_i
    end
    movie.save
    # people
    $roles.length.times do |i|
      count = 0
      doc.each_element("movie/crew/department[@title='#{$roles[i].titleize}']/person") do |e|
        person = Person.find_or_create_by_omdb e.omdb_id
        person.name = e.elements['name'].text
        person.save
        movie.departments.each {|d| d.destroy }
        Department.create(:role => i, :person => person, :movie => movie, :number => count)
        count += 1
      end
    end
    
    # genres
    movie.genres = []
    doc.each_element("movie/genres/genre") do |e|
      genre_omdb = Category.find(e.omdb_id).genre_id
      genre = Genre.find_or_create_by_omdb genre_omdb
      unless genre.movies.include? movie
        genre.name = $genres.invert[genre_omdb]
        genre.movies << movie
        genre.save
      end
    end
    
    # countries
    movie.countries = []
    doc.each_element("movie/countries/country") do |e|
      country = Country.find_by_iso_3166 e.text
      movie.countries << country if country
    end
      
    movie.save
    movie.reload # reload for ferret indexing
  rescue
  end
  
  class REXML::Element
    def omdb_id
      self.elements['url'].text[/\d+/].to_i if self.elements['url']
    end
  end
  
  
end
