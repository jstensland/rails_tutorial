class UsersController < ApplicationController
 
  def show
    @user = User.find(params[:id])
  end
 
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      log_in @user
      #this is equivalent to redirect_to user_url(@user) in Rails
      flash[:success] = "Welcome to the Sample App!"
      #this is equivalent to redirect_to user_url(@user) in Rails
      redirect_to @user #sends you to your profile page if you sign up
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
