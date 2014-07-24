class UsersController < ApplicationController

  def new
    @user = User.find_by(session[:user_id])
    # @user = User.new
    @user.facebook
  end
 
  def update
    #raise params.inspect
    # @user = User.new(user_params)
    @user = User.find_by(session[:user_id])
    @user.phone = user_params[:phone]
    @user.save
    binding.pry
    if @user.save
      # notice "Thank you! You will receive an SMS shortly with verification instructions."
      render text: "Thank you! You will receive an SMS shortly with verification instructions."
      # redirect_to '/users/new'
      # create a link
      # @facebook ||= Koala::Facebook::API.new(user_params[:oauth_token])
      # binding.pry
      
      # Instantiate a Twilio client
      client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
      
      # Create and send an SMS message
      client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: @user.phone,
        body: "HEY #{@user.name}! YOU ARE AWESOME!"
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
