class RatingsController < ApplicationController
  before_filter :authorize
  verify :xhr => true, :redirect_to => { :controller => 'movierok' }, :except => :index
  verify :params => :rip_id, :redirect_to => { :controller => 'movierok' }, :except => :index
  
  after_filter :delete_cache, :except => :index
 
  
  def create
    @rip = Rip.find(params[:rip_id])
    if @rip
      if logged_in_user.has_rip?(@rip)
        rating = Rating.find_or_initialize_by_type_id_and_rip_id_and_user_id(
          params[:rating][:type_id], params[:rip_id], logged_in_user.id
        )
        rating.rating = params[:rating][:rating]
        rating.save
        type = $ratings[params[:rating][:type_id].to_i - 1]
        render :partial => 'ratings/rating', :locals => {:type => type}
      else
        render :text => '<span class="info">you don\'t have this rip</span>'
      end
    end
  end
  
  
  private
  def delete_cache
    expire_action rip_url(@rip)
    expire_fragment("rips/fragments/#{@rip.id}")
    RipSweeper.delete_ratings(logged_in_user)
  end
  
end
