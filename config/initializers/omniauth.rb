Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["LOGIN_AUTH"], ENV["LOGIN_SECRET"]
end
