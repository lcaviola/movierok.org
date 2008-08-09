class MovierokController < ApplicationController
  
  before_filter :authorize, :only => :help
  
  def index
    if logged_in_user
      redirect_to user_rips_path(logged_in_user)
    else
      redirect_to about_url
    end
  end
  
  def about
  end
  
  def help
  end
  
  def sitemap
    @rips = Rip.find(:all, :select => 'id, movie_id', :include => :movie) 
    headers["Content-Type"] = 'application/xml'
  end
  
  def advanced_search
    render :layout => false
  end
  
  def ffextversion
    render :json => $compatible_ff_ext_versions
  end
    
end
