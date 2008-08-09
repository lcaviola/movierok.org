class SessionsController < ApplicationController
  before_filter :authorize, :only => [:destroy]
  
  def create
    user = User.authenticate(params[:name], params[:password])
    session[:user_id] = user.id if user
    redirect_to request.referer || root_url
  end

  def destroy
    cookies[:user_name] = nil
    session[:user_id] = nil
    redirect_to request.referer || root_url
  end
  
end
