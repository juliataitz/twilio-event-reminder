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

  def facebook
    # @user = User.find_by(session[:user_id])
    @user = User.all.last
    #fb_statuses = []
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    #binding.pry
    @user_profile = @facebook.get_object("me")
    @statuses = @facebook.get_connections(@user_profile["id"], "statuses")
    @statuses.each do |status|
      # fb_statuses << status["message"]
      @user.messages.each do |message|
        message.content = status["message"]
      end
      #binding.pry
      # @user.build_message(:content => status["message"] )
    end
    @user.save
  end


end
