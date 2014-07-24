class User < ActiveRecord::Base

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
  
  def facebook
    fb_statuses = []
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    @user_profile = @facebook.get_object("me")
    @statuses = @facebook.get_connections(@user_profile["id"], "statuses")
    # binding.pry
    @statuses.each do |status|
      fb_statuses << status["message"]
    end
    # @facebook.get_connections(@user_profile["id"], "statuses")[0]["message"] gets first status
    # @facebook.get_connections(@user_profile["id"], "statuses")[0]["updated_time"] gets time of first status
  end


end
