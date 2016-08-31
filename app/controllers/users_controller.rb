class UsersController < ApplicationController
  
  #  before filters
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]  # runs the method logged_in_user before index, destroy, edit & update actions
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  # show all users (only logged in members)
  def index
    @users = User.paginate(page: params[:page])  # paginate is gem
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create  # Runs with every click of "Create account" button
    @user = User.new(user_params)
    if @user.save  # save to db
      log_in @user  # log in freshly signed up user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  private

    def user_params  # require a user hash & let only name,email,pass,passconf attributes be passed to returned hash
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
  
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)  # current_user is method in sessions_helper.rb
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
