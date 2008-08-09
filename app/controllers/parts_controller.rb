class PartsController < ApplicationController
  before_filter :authorize, :make_parts_array

  # GET /parts
  def index
    parts = logged_in_user.parts.find(:all, :select => :check_sum)
    respond_to do |format|
      format.xml { render :xml => parts }
      format.json { render :json => parts.to_json }
    end
  end

  # GET /parts/incomplete
  def incomplete
    parts = logged_in_user.parts.find(:all, :select => :check_sum, :conditions => ['video_encoding IS NULL'])
    respond_to do |format|
      format.xml { render :xml => parts }
      format.json { render :json => parts.to_json }
    end
  end

  # POST /parts
  # add parts to logged_in_user (only check_sums)
  def create
    # TODO:..
    conf = {:path=>"#{RAILS_ROOT}/index/#{RAILS_ENV}/rip"}
    index = Ferret::Index::Index.new(conf)

    for p in params[:parts][:part]
      part = Part.find_or_create_by_check_sum(p[:check_sum])
      unless logged_in_user.parts.include? part
        logged_in_user.parts << part
        #part.rip.ferret_update if part.rip
        update_user_in_field(:index => index, :part => part, :add => true)
      end
    end
    expire_fragment("/rips/ratings/#{logged_in_user.id}")
    #    cache_file = "#{RAILS_ROOT}/tmp/cache/rips/ratings/#{logged_in_user.id}.cache"
    #    File.delete(cache_file) if File.exist?(cache_file)
    head :created
  end

  # PUT /parts/complete
  # complete meta data
  def complete
    for p in params[:parts][:part]
      part = Part.find_by_check_sum(p[:check_sum])
      part.update_attributes(p)
      expire_action rip_url(part.rip) if part.rip
    end
    head :ok
  end

  # PUT /parts/remove
  # remove parts from logged_in_user
  def remove
    conf = {:path=>"#{RAILS_ROOT}/index/#{RAILS_ENV}/rip"}
    index = Ferret::Index::Index.new(conf)

    check_sums = params[:parts][:part].collect {|p| p[:check_sum]}
    parts = Part.find_all_by_check_sum(check_sums)
    logged_in_user.parts.delete(parts)
    parts.each do |part|
      #part.rip.ferret_update if part.rip
      update_user_in_field(:index => index, :part => part, :remove => true)
    end
    head :ok
  end


  private

  def make_parts_array
    if params[:parts] and params[:parts][:part] and not params[:parts][:part].instance_of? Array
      params[:parts][:part] = [params[:parts][:part]]
    end
  end


  def update_user_in_field(o = {})
    unless o[:part].rip_id.blank?
      hits = o[:index].search("id:#{o[:part].rip_id}").hits
      if hits.size > 0
        doc = o[:index][hits.first.doc]
        doc.load
        doc[:user] = [doc[:user]] if doc[:user].class == String
        if o[:add]
          doc[:user] << logged_in_user.name unless doc[:user].include? logged_in_user.name
        else
          doc[:user].delete logged_in_user.name
        end
        o[:index].query_update("id:#{o[:part].rip_id}", doc)
      end
    end
  end

end

