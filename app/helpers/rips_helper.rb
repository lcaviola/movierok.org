module RipsHelper

  def dl_item(label, value)
    "<dt>#{label}</dt>\n<dd>#{value}</dd>" unless value.blank?
  end

  def rip_title_with_year(rip)
    res = link_to rip.movie.title, rip_path(rip)
    res << " #{rip.movie.year}" if rip.movie.year
    res
  end

  def alternating_item_background
    @toggle_stripes = true unless defined?(@toggle_stripes)
    @toggle_stripes = !@toggle_stripes
    'dark_rip_item' if @toggle_stripes
  end

  def selected_link(value, key = nil)
    if (params[value] and params[value] == key) or (key == nil and not params[value])
      ' selected_riplist_navigation_link'
    else
      ''
    end
  end

  def cover_alt_text(rip)
    res = "&lt;a href=&quot;#{rip_url(rip)}&quot;&gt;#{h rip.movie.title}&lt;/a&gt;"
    res << "&lt;p&gt;#{rip.movie.year} &lt;br/&gt; &lt;span class=&quot;play_link&quot;&gt;"
    res << "#{rip.parts.collect(&:mrokhash).join('+')}&lt;/span&gt;&lt;/p&gt;"
    res
  end

  def unknown_parts(rip)
    parts = logged_in_user.unknown_parts
    parts -= rip.part_files unless rip.part_files.nil?
    parts
  end

  def hint(message, style = '')
    "<span class='hint' style='#{style}'>#{message}<span class='hint-pointer'>&nbsp;</span></span>"
  end

  def rip_info_attrs(rip)
    if rip.new_record? and rip.part_files.nil?
      {:style => 'display:none'}
    else
      {}
    end
  end

  def whose_rips
    (params[:user_id]) ? User.find_by_name(params[:user_id]).name + "'s" : ''
  end

  def hidden_language_field(type, rip, lang)
    disabled = (rip and rip.send(type + 's').include? lang) ? '' : 'disabled="true"'
    return "<input type='hidden' name='rip[#{type}_ids][]' value='#{lang.id}' #{disabled} />"
  end

  def selected_lang_class(type, rip, lang)
    (rip and rip.send(type + 's').include? lang) ? ' enabled_lang' : ''
  end

  def total_rips_count(rips)
    (rips.respond_to?(:total_entries)) ? rips.total_entries : rips.total_hits
  end

  def search_link(key, name, value = name)
    value = "\"#{value}\"" if value.include? ' '
    options = {:search => "#{key}:#{value.downcase}"}
    url = rips_path(options)
    link = link_to(name, url, :class => 'search_link')
    clean_colon link
  end


  # no html entities for colons (clean url)
  def clean_colon(link)
    link['%3A'] = ':' if link['%3A']
    link
  end

  def auto_pagination(rips, search)
    url, p = get_url_and_parameters(search)
    javascript_tag "append_auto_pagnation('#{url}.js', '#{total_rips_count(rips)}', 2, 1000, '#{p}'); $('pagination').remove()"
  end


  def image_flow(rips, search)
    url, p = get_url_and_parameters(search)
    url << "/covers.js"
    s = javascript_include_tag('imageflow')
    s << javascript_tag("init_image_flow(#{total_rips_count(rips)}, '#{url}', '#{p}')")
    s
  end



  # TODO: refactor
  def get_url_and_parameters(search)
    p = ''
    p << "search=#{search.escape_single_quotes}" if search
    p << "&" unless p.blank?
    p << "sort=title" if params[:sort] and params[:sort] == 'title'
    p << "&" unless p.blank?
    p << 'order=down' if params[:order] and params[:order] == 'down'
    url = "/rips"
    url = "/users/#{params[:user_id]}#{url}" if params[:user_id]
    return url, p
  end

  def covers_url
    url = covers_rips_path(parameters_as_hash)
    url = "/users/#{params[:user_id]}#{url}" if params[:user_id]
    clean_colon url
  end

  def list_url(o = {})
    p = parameters_as_hash
    p.merge!(o)
    p.delete_if {|key, value| value.nil? }
    url = if params[:user_id]
      user_rips_path(params[:user_id], p)
    else
      rips_path(p)
    end
    clean_colon url
  end


  def parameters_as_hash
    parameters = Hash.new
    parameters[:search] = params[:search] unless params[:search].blank?
    parameters[:sort] = params[:sort] unless params[:sort].blank?
    parameters[:order] = params[:order] unless params[:order].blank?
    return parameters
  end


  def part_information(part)
    res = "#{number_to_human_size(part.filesize)}"
    res << " / #{part.duration_in_minutes}&nbsp;min" unless part.duration_in_minutes.blank?
    res
  end

  def countries_information(movie)
    movie.countries.collect do |country|
      search_link(:country, country.name, country.iso_3166.upcase)
    end.to_sentence
  end


end

