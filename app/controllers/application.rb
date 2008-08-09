class ApplicationController < ActionController::Base
  # protect_from_forgery
  before_filter :check_for_user_name_cookie
  
  def authorize
    unless logged_in_user
      authenticate_with_http_basic do |name, password|
        @logged_in_user = User.authenticate(name, password)
        session[:user_id] = @logged_in_user.id if @logged_in_user
      end
      unless logged_in_user
        respond_to do |format|
          format.js { render :text => '<span class="info">please login</span>'}
          format.html { redirect_to root_url }
          format.xml { request_http_basic_authentication 'Web Password' }
          format.json { request_http_basic_authentication 'Web Password' }
        end
      end
    end
  end
  
  def logged_in_user
    @logged_in_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
  def check_for_user_name_cookie
    cookies[:user_name] = logged_in_user.name if logged_in_user
    cookies[:user_name] = nil if not logged_in_user and cookies[:user_name]
  end

  
end
