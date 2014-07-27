class User < ActiveRecord::Base
  has_many :messages

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.signups = 0 if user.signups.nil?
      user.save!
    end

  end


  def message_content
    @user = get_user_profile
    @statuses = @facebook.get_connections(@user["id"], "statuses")
    @todays_message = @statuses.sample
    @content = @todays_message["message"]
    @time = Date.parse(@todays_message['updated_time']).strftime('%m/%d/%Y') 
    return "#{@content} ##{@time}"
  end



  def send_message
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
    client.account.messages.create(
      from: TWILIO_CONFIG['from'],
      to: phone,
      body: message_content
    )
  end

  def self.send_all_messages

  end

  def valid_phone_num?
    self.phone.gsub!(/\D/, "") == 10
  end

  private

  def get_user_profile
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    @facebook.get_object("me")
  end

  def get_user_messages
    @user = get_user_profile
    @statuses = @facebook.get_connections(@user["id"], "statuses")
  end

end
