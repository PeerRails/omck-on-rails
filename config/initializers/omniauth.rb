Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV['LOGIN_AUTH'], ENV['LOGIN_SECRET']
end