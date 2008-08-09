class UsersController < ApplicationController
  before_filter :authorize, :only => [:edit, :update]
  before_filter :authorize_as_user, :only => [:edit, :update]
  before_filter :not_logged_in, :only => [:new, :create]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.find_all_with_created_rips_count
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    redirect_to user_rips_path(params[:id])
  end
  
  def lost_password
    user = User.find_by_email params[:email]
    if user
      Mailer.deliver_lost_password user
      flash[:notice] = "An email has been sent to #{params[:email]}."
    else
      flash[:notice] = "No user with this email address found."
    end
    redirect_to new_user_path
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by_name(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Hi #{@user.name}, welcome to movierok!"
      redirect_to(help_url) 
    else
      render :action => 'new'
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find_by_name(params[:id])
    if @user.update_attributes(params[:user])
      cookies[:local_url] =  { :value => params[:local_url], :path => '/' }
      redirect_to(edit_user_path(@user))
    else
      render :action => 'edit'
    end
  end
  
  
  # DELETE /users/1
  # DELETE /users/1.xml
  #  def destroy
  #    @user = User.find(params[:id])
  #    @user.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to(users_url) }
  #      format.xml  { head :ok }
  #    end
  #  end
  
  private
  def authorize_as_user
    redirect_to root_url unless logged_in_user.name == params[:id]
  end
  
  def only_admins
    redirect_to root_url if logged_in_user.nil? or not [1,2].include? logged_in_user.id
  end
  
  def not_logged_in
    redirect_to root_url if logged_in_user
  end
end
