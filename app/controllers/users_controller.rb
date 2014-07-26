class UsersController < ApplicationController

  def new
    @user = User.find_by(session[:user_id])
  end
 
  def update
    @user = User.find_by(session[:user_id])
    @user.phone = user_params[:phone]
    if @user.save
      @user.send_message
      render '/users/successful_signup'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :oauth_token)
  end

end
