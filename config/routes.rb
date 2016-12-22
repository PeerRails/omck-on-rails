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

  # Home
  scope '/home' do
    get 'get_me' => 'home_key#get_me'
    get 'get_key' => 'home_key#get_key'
    get 'get_secret' => 'home_key#get_secret'
    post 'update_key' => 'home_key#update_key'
    get 'regenerate_key' => 'home_key#regenerate_key'
  end

  # Channels
  scope '/channels' do
    get 'live' => 'channels#live'
    get 'all' => 'channels#all'
    get ':service/:channel/show' => 'channels#show'
    get ':service/show' => 'channels#show'
    post 'create' => 'channels#create'
    put ':service/:channel/update' => 'channels#update'
    delete ':service/:channel/destroy' => 'channels#destroy'
    get ':service/:channel/switch' => 'channels#switch'
  end


end
