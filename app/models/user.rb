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
    # binding.pry
    @time = Date.parse(@todays_message['updated_time'])
    # if @content.length + 32 > 160
    #   @content = "On #{@time}, you said: #{@content[0..120]}..."
    # else
    #   @content = "On #{@time}, you said: #{@content}"
    # end
    if @content.length < 160
      message_content
    else
      binding.pry
      @content = "On #{@time}, you said: #{@content}"
    end
  end

  private

  def get_user_profile
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    @facebook.get_object("me")
  end

end
