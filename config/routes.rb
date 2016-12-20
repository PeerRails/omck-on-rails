Rails.application.routes.draw do

  # Root
  root :to => 'frontpage#index'
  get 'home' => 'frontpage#index'
  get 'player' => 'frontpage#player'
  get 'faq' => 'frontpage#faq'

  # Sessions
  get 'sessions/login' => 'session#login'
  get 'login' => 'session#login' # Legacy?
  post 'sessions' => 'session#create'
  delete 'sessions' => 'session#destroy'

  # Registration
  get 'signup/new' => 'signups#new'
  post 'signup/create' => 'signups#create'
  get '/auth/:provider/callback' => 'omniauth_callbacks#login'
  get '/auth/:provider' => 'omniauth_callbacks#passthru'

  # Channels
  get 'channels/live' => 'channels#live'
  get 'channels/all' => 'channels#all'
  get 'channels/:service/:channel/show' => 'channels#show'
  get 'channels/:service/show' => 'channels#show'
  post 'channels/create' => 'channels#create'
  post 'channels/:service/:channel/update' => 'channels#update'
  delete 'channels/:service/:channel/destroy' => 'channels#destroy'
  get 'channel/:service/:channel/switch' => 'channels#switch'

end
