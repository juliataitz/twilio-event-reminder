class User < ActiveRecord::Base
  has_many :messages

  attr_accessor :phone

  # validates :phone, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end

  end

  def message_content
    @user_profile = get_user_profile
    @statuses = @facebook.get_connections(@user_profile["id"], "statuses")
    @todays_message = @statuses.sample
    @content = @todays_message["message"]
    @time = Date.parse(@todays_message['updated_time']).strftime('%m/%d/%Y') 
    return "#{@content} ##{@time}"
  end

  private

  def get_user_profile
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    @facebook.get_object("me")
  end

end
