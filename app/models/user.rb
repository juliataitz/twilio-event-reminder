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

  # def facebook
  #   # @user = User.find_by(session[:user_id])
  #   # @user = User.find_by(:id)
  #   @user = User.all.first
  #   fb_statuses = []
  #   fb_times = []
  #   @facebook ||= Koala::Facebook::API.new(oauth_token)
  #   #binding.pry
  #   @user_profile = @facebook.get_object("me")
  #   @statuses = @facebook.get_connections(@user_profile["id"], "statuses")
  #   @statuses.each do |status|
  #     fb_statuses << status["message"]
  #     fb_times << status["updated_time"]
  #     # @user.messages.each do |message|
  #     #   message.content = status["message"]
  #     # end
  #     # binding.pry
  #     # @user.build_message(:content => status["message"] )
  #   end
  #   # return today_status(fb_statuses, fb_times)
  #   return today_status(fb_statuses)
  #   # @user.save
  # end
    def facebook
    # @user = User.find_by(session[:user_id])
    # @user = User.find_by(:id)
    @user = User.all.first
    # fb_statuses = []
    # fb_times = []
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    #binding.pry
    @user_profile = @facebook.get_object("me")
    @statuses = @facebook.get_connections(@user_profile["id"], "statuses")
    binding.pry
    @today_status = @statuses.raw_response["data"].choice
    @today_status_message = @today_status['message']
    return @today_status_message
    # @statuses.each do |status|
    #   fb_statuses << status["message"]
    #   fb_times << status["updated_time"]
    #   # @user.messages.each do |message|
    #   #   message.content = status["message"]
    #   # end
    #   # binding.pry
    #   # @user.build_message(:content => status["message"] )
    # end
    # # return today_status(fb_statuses, fb_times)
    # return today_status(fb_statuses)
    # @user.save
  end

  # def today_status(fb_statuses)
  #   index = Random.rand(1..fb_statuses.length)
  #   @today_status = fb_statuses[index]
  #   # @today_time = fb_times[index]
  #   if @today_status.length + 15 > 160
  #     @today_status = @today_status[0..140] + "..."
  #   else
  #     @today_status
  #   end
  #   # @today_time
  #   # binding.pry
  # end


end
