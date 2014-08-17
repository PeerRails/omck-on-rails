Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["TWITTER_1"], ENV["TWITTER_2"]
end
