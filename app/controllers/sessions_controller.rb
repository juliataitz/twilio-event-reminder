class SessionsController < ApplicationController

  def create
    @user = User.from_omniauth(env["omniauth.auth"]) # changed these to instance variables
    session[:current_user] = @user # added this
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

  def destroy
    session[:user_id] = nil
    redirect_to user_path(@user)
  end

end
