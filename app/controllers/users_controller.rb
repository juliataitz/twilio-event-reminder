class UsersController < ApplicationController

  def new
    @user = User.find_by(session[:user_id])
  end
 
  def update
    @user = User.find_by(session[:user_id])
    @user.phone = params[:user][:phone]
    if @user.save
      @user.send_message
      render '/users/successful_signup'
    else
      render :new
    end
  end

end
