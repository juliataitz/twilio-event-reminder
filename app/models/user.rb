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

  def has_messages?
    !self.messages.empty?
  end

  def message_content
    if !messages_depleted?
      message = self.messages.where(deployed: false).sample
      message.deployed = true
      message.save

      time = message.posted_time.strftime('%m/%d/%Y')
      "#{message.content} ##{time}"
    else
      "sorry but we don't have more statuses for you, feel free to sign up again!" 
    end
  end

  def store_status_messages
    statuses = get_user_status_messages
    statuses.each do |status|
      self.messages.create(content: status["message"], posted_time: status["updated_time"])
    end
  end

  def send_message
    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
    client.account.messages.create(
      from: TWILIO_CONFIG['from'],
      to: phone,
      body: message_content
    )
  end

  def self.send_daily_messages
    self.all.each do |user|
      binding.pry
      user.send_message unless user.messages_depleted?
    end
  end

  def valid_phone_num?
    self.phone.gsub!(/\D/, "") == 10
  end

  def messages_depleted?
    Message.where("user_id = ?", self.id).where(deployed: false).empty?
  end

  private

  def get_user_profile
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    @facebook.get_object("me")
  end

  def get_user_status_messages
    @user = get_user_profile
    @statuses = @facebook.get_connections(@user["id"], "statuses")
    @statuses.shuffle!.slice(0, 14)
  end

end
