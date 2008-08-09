class RipsController < ApplicationController
  
  before_filter :authorize, :except => [:index, :show, :covers]
  before_filter :set_editor_id, :only => [:create, :update]
  before_filter :authorize_as_rip_owner, :only => [:edit, :update, :restore]
  
  caches_action :show # TODO: page cache here. prob: update, delete etc. takes cache files
  cache_sweeper :rip_sweeper, :only => [:update, :create, :restore]
  
  # GET /rips
  # GET /rips.xml
  def index
    cookies[:default_view] = { :value => 'list', :expires => 6.month.from_now }
    @rips = Rip.get(params)
    respond_to do |format|
      format.html
      format.rss
      format.xml  { render :xml => @rips.to_xml }
      format.js { render :partial => 'rip', :collection => @rips }
      format.json { render :json => @rips.to_json }
    end
  end
  
  # GET /rips/1
  # GET /rips/1.xml
  def show
    @rip = Rip.find params[:id]
    respond_to do |format|
      format.html
      format.xml  { render :xml => @rip.to_xml }
    end
  end
  
  # GET /rips/1/versions
  def versions
    @rip = Rip.find params[:id]
  end
  
  # GET /rips/new
  def new
    @rip = Rip.new
  end
  
  # GET /rips/1;edit
  def edit
    @rip = Rip.find(params[:id])
  end
  
  # POST /rips
  # POST /rips.xml
  def create
    @rip = Rip.new(params[:rip])  
    respond_to do |format|
      if @rip.save
        format.html { redirect_to rip_url(@rip) }
        format.xml  { head :created, :location => rip_url(@rip) }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @rip.errors.to_xml }
      end
    end
  end
  
  # PUT /rips/1
  # PUT /rips/1.xml
  def update
    @rip = Rip.find(params[:id])
    respond_to do |format|
      if @rip.update_attributes(params[:rip])
        format.html { redirect_to rip_url(@rip) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @rip.errors.to_xml }
      end
    end
  end
  
  # PUT /rips/1/restore
  def restore
    @rip = Rip.find(params[:id])
    @rip.revert_to!(params[:version])
    expire_action rip_url(@rip)
    redirect_to rip_url(@rip)
  end
  
  # GET /covers
  def covers
    @rips = Rip.get(params, :per_page => 60)
    cookies[:default_view] = { :value => 'covers', :expires => 6.month.from_now }
  end
  
  #  # DELETE /rips/1
  #  # DELETE /rips/1.xml
  #  def destroy
  #    @rip = Rip.find(params[:id])
  #    @rip.destroy
  #    
  #    respond_to do |format|
  #      format.html { redirect_to rips_url }
  #      format.xml  { head :ok }
  #    end
  #  end
  
  def releasers
    @releasers = Rip.find_releasers_like(params[:rip][:releaser])
    render :inline => "<%= auto_complete_result(@releasers, 'releaser') %>"
  end


  private 
  
  
  def set_editor_id
    params[:rip][:editor_id] = logged_in_user.id
  end
  
  def authorize_as_rip_owner
    rip = Rip.find(params[:id])
    redirect_to rip_url(rip) unless logged_in_user.has_rip?(rip)
  end
  
end