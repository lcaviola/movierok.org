# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def html_title(rip)
    title = ''
    title = rip.movie.title if rip and rip.movie 
    title = h("rips with #{params[:search]}") if params[:search]
    title = 'rips' if @rips and params[:search].blank?
    title = 'new rip' if @rip and @rip.new_record?
    title << ' on ' unless title.blank?
    title << 'movierok.org'
  end
  
  def logged_in_user
    @logged_in_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
  def link_to_firefox_extension(version)
    link_to 'firefox extension', "/movierok-#{version}.xpi", :class => 'extension',
      :onclick => "return installExtension(event, 'movierok', 'http://movierok.org/images/logo64.png')"
  end
  
  def include_all_javascript_files
    javascript_include_tag 'lib/prototype', 'lib/builder', 'lib/effects',
      'lib/controls', 'lib/dragdrop', 'lib/cookie', 'movierok','auto_pagination',
      :cache => true
  end

  
  def types_as_array
    i = 0
    $types.collect do |v| 
      i += 1
      [v, i]
    end
  end
  
  def meta_description(rip = @rip)
    if rip and rip.movie
      res = "#{rip.movie.title}"
      res << " (#{rip.movie.year})" if rip.movie.year
      res << " rip released by #{rip.releaser.downcase}" unless rip.releaser.blank?
      res << " " + pluralize(rip.parts.length, 'part')
      res << " on movierok.org"
    else
      "movierok is an open database for movie rips. movierok will find and organize all rips you've got and allows you to browse, search, and start them in your webbrowser."
    end
  end
  
  def meta_keywords
    keywords = ''
    if @rip and @rip.movie
      keywords << @rip.movie.title.downcase + ', '
      keywords << @rip.releaser.downcase + ', ' unless @rip.releaser.blank?
      keywords << @rip.movie.genres.collect(&:name).collect(&:downcase).join(', ') + ', ' unless @rip.movie.genres.empty?
    end
    keywords << 'rip, movie, film, database, open, moviefile, movie file'
    keywords
  end
  
  def meta_tag(name, content)
    name.gsub!(/"/, '\\\"')
    content.gsub!(/"/, '\\\"')
    "<meta name=\"#{name}\" content=\"#{content}\" />"
  end
  
  def rss_url
    if params[:user_id]
      formatted_user_rips_url(params[:user_id], :rss) 
    else
      formatted_rips_url(:rss)
    end
  end
  
end
