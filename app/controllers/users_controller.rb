class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
 
  def update
    @user = User.find_by(id: session[:user_id])
    @user.phone = params[:user][:phone]
    @user.signups += 1
    if @user.save
      @user.store_status_messages unless @user.has_messages?

      @user.send_message # unless user.signups > 0
      render '/users/successful_signup'  
    else
      render :new
    end
  end

end

