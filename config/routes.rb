Rails.application.routes.draw do
  # Root
  root :to => 'frontpage#index'
  # auth
  # get 'auth_session' => 'application#session_auth' #why I even need this
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  get 'login', :to => 'users/sessions#new', :as => :new_user_session
  get 'logout', :to => 'users/sessions#destroy', :as => :destroy_user_session

  # Channel API
  get 'channel/live' => 'channels#list_live', defaults: { page: 0 }
  get 'channel/all' => 'channels#list_all', defaults: { page: 0 }
  get 'channel/:service/:channel' => 'channels#show'
  #get 'service/:service' => 'channels#service_list', defaults: { service: 'hd' }
  post 'channel/new' => 'channels#create'
  put 'channel/:service/:channel/update' => 'channels#update'
  delete 'channel/:service/:channel/remove' => 'channels#remove'

  # User API
  get 'users' => 'users#list'
  get 'user/:id' => 'users#show'
  get 'user/:id/videos' => 'users#videos'
  #post 'user/:twitter_id/update' => 'users#update'
  post 'user/:id/grant' => 'users#grant'
  post 'user/invite' => 'users#invite'

  #match 'user/guest/auth' => 'users#guest_in', via: [:get, :post]
  #get 'user/guest/videos' => 'user#guest_video'

  # Key API
  get 'home/your_keys' => 'keys#list'
  get 'home/secret/:id' => 'keys#secret'
  get 'home/streamer_keys' => 'keys#streamers'
  get 'home/guest_keys' => 'keys#guests'
  post 'home/keys/create' => 'keys#create'
  post 'home/keys/create/guest' => 'keys#create_guest'
  post 'home/keys/expire' => 'keys#expire'
  post 'home/keys/expire/guest' => 'keys#expire_guest'
  post 'home/keys/regenerate' => 'keys#regenerate'
  post 'home/keys/update' => 'keys#update'

  # Video API
  get 'home/video' => 'videos#list'
  #post 'video/:id/save' => 'videos#save'
  delete 'home/video' => 'videos#remove'

  #Twitter
  post 'home/tweets' => 'tweets#tweet'
  get 'home/user/tweet' => 'tweets#list'

  #API tokens
  get 'home/token' => 'api_tokens#list'
  get 'home/tokens' => 'api_tokens#list_all'
  get 'home/token/:user_id/show' => 'api_tokens#show'
  post 'home/token/create' => 'api_tokens#create'
  post 'home/token/expire' => 'api_tokens#expire'


  # Pages:
  get 'home' => 'home#admin'
  get 'player' => 'frontpage#player'
  #get 'home/login' => 'home#login'
  #get 'home/' => 'home#cabinet'
  #get 'home/faq' => 'home#faq'
  #get 'home/admin' => 'home#admin'

  #API
  namespace :api, defaults: {format: 'json'} do
    # Version 1.0
    namespace :v1 do
      # Channels API
      get 'channels/live' => 'channels#live'
      get 'channels/all' => 'channels#all'
      get 'channels/:service/:channel' => 'channels#show'
      get 'channels/:service' => 'channels#service'
      post 'channels/create' => 'channels#create'
      post 'channels/:service/:channel/update' => 'channels#update'
      delete 'channels/:service/:channel/delete' => 'channels#delete'

      # Keys API
      get 'keys' => 'keys#retrieve'
      get 'keys/all' => 'keys#all'
      get 'keys/guest' => 'keys#guest'
      post 'keys/create' => 'keys#create'
      post 'keys/regenerate' => 'keys#regenerate'
      post 'keys/update' => 'keys#update'
      delete 'keys/expire' => 'keys#expire'

      # Users API
      get 'users' => 'users#list'
      get 'user/:id' => 'users#show'
      get 'user/:id/videos' => 'users#videos'
      post 'user/:id/update' => 'users#update'
      post 'user/:id/grant' => 'users#grant'
      post 'user/invite' => 'users#invite'

      # Videos API
      get 'videos' => 'videos#list'
      get 'videos/archive' => 'videos#list', defaults: { deleted: "true" }
      get 'video/:token' => 'videos#show'
      post 'video/add' => 'videos#add'
      post 'video/:token/update' => 'videos#update'
      delete 'video/:token/archive' => 'videos#archive'
      post 'video/:token/archive' => 'videos#archive'

      # Tweets API
      get 'tweets' => 'tweets#list'
      #get 'tweets/timeline' => 'tweets#timeline'
      get 'tweets/:id' => 'tweets#show'
      get 'tweets/user/:user_id' => 'tweets#by_user'
      post 'tweets/post' => 'tweets#post'
      delete 'tweets/:id/delete' => 'tweets#delete'
    end
  end

  # bitdash
  #get 'bitdash/:channel' => 'channels#bitdash', defaults: { channel: 'records' }

  # avconv -re -i /home/prails/Downloads/stream.flv -f flv rtmp://localhost:1935/live/omckws?key=50adf9fc-8499-4d45-b499-de831586cd9a
  #     #Auth
  #     match '/auth/:provider/callback' => 'users#login', via: [:get, :post]
  #     get 'auth_session' => 'application#session_auth'
  #     get 'logout' => 'users#logout'
  #     #post 'home/manage_perm' => 'users#manage_perm'
  #     #post 'home/remove_streamer' => 'users#remove_streamer'
  #
  #     #Old Home
  #     #get 'home' => 'staff#index'
  #
  #     #API
  #     get 'channel/move_record' => 'nginx#move_record'
  #     get 'channel/live' => 'streams#get_live'
  #     get 'channel/all' => 'streams#get_all'
  #     get 'channel/:service/:channel' => 'streams#get_channel'
  #
  #     #bitdash
  #     get 'bitdash/:channel' => 'channels#bitdash'
  #     get 'bitdash' => 'channels#bitdash'
  #
  #     #NGINX Controller
  #     get 'auth_stream' => 'nginx#get_key'
  #     post 'auth_stream' => 'nginx#get_key'
  #     get 'incr_stream' => 'nginx#increase_viewer_count'
  #     get 'decr_stream' => 'nginx#decrease_viewer_count'
  #     get 'end_cinema' => 'nginx#end_cinema'
  #
  #     #Keys
  #     get 'home/remake_key' => 'keys#remake_key'
  #     post 'home/make_key' => 'keys#make_key'
  #     post 'home/change_key' => 'keys#change_key'
  #     post 'home/expire_key' => 'keys#expire_key'
  #
  #     #Pages
  #     get 'faq' => 'home#faq'
  #     get 'faq-irc' => 'home#faq_irc'
  #     get 'guest' => 'home#guest'
  #     post 'guest' => 'home#guest'
  #
  #     #Channel CRUD
  #     post 'home/channel/new' => 'channels#new'
  #     post 'home/channel/edit' => 'channels#edit'
  #     post 'home/channel/delete' => 'channels#delete'
  #
  #     #Tweet Controller
  #     post 'home/tweet' => 'tweets#tweet'
  #
  #     #Video
  #     get 'user/vids' => 'videos#list'
  #     get 'user/vids/check' => 'videos#check_deleted'
  #     delete 'user/vids/delete' => 'videos#delete'
end
