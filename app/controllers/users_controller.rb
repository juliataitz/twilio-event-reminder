class UsersController < ApplicationController

  def new
    @user = User.find_by(session[:user_id])
    @user.message_content
  end
 
  def update
    @user = User.find_by(session[:user_id])
    @user.phone = user_params[:phone]
    @user.save
    if @user.save
      render text: "Thank you! You will receive an SMS shortly with verification instructions."

      client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
      
      client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: @user.phone,
        body: "#{@user.message_content}"
      )
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :oauth_token)
  end

end
