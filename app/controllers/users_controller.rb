class UsersController < ApplicationController
  
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
  
  
  private

    def user_params  # require a user hash & let only name,email,pass,passconf attributes be passed to returned hash
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
end
