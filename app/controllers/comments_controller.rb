class CommentsController < ApplicationController
  before_filter :authorize
  
  def create
    rip = Rip.find params[:rip_id]
    @comment = Comment.new(params[:comment])
    @comment.rip = rip
    @comment.user = logged_in_user  
    if @comment.save
      remove_cache_pages(rip.id) if rip
    end
    redirect_to(rip)
  end

end
