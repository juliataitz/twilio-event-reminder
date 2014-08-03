OmniAuth.config.logger = Rails.logger



Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, '686777364747791', '784ccf4048f7ddc92b69e6a672bf4b32', :scope => 'user_status'

end