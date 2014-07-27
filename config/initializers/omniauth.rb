OmniAuth.config.logger = Rails.logger



Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, '746118258758609', '6e3f2f33eb3a3cc0c9349eea2833ef63', :scope => 'user_status'

end