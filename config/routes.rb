Rails.application.routes.draw do
  # Root
  root :to => 'frontpage#index'
  
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
      get 'keys/authorize' => 'keys#authorize'
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
      get 'videos/unarchived' => 'videos#list', defaults: { deleted: "false" }
      get 'videos/archive' => 'videos#list', defaults: { deleted: "true" }
      get 'video/:token' => 'videos#show'
      post 'video/add' => 'videos#add'
      post 'video/:token/update' => 'videos#update'
      delete 'video/:token/archive' => 'videos#archive'
      post 'video/:token/archive' => 'videos#archive'
      get 'video/:token/path' => 'videos#path'

      # Tweets API
      get 'tweets' => 'tweets#list'
      #get 'tweets/timeline' => 'tweets#timeline'
      get 'tweets/:id' => 'tweets#show'
      get 'tweets/user/:user_id' => 'tweets#by_user'
      post 'tweets/post' => 'tweets#post'
      delete 'tweets/:id/delete' => 'tweets#delete'

      # Streams API
      get 'streams/last' => 'streams#last', defaults: {user: nil}
      get 'streams/:user/last' => 'streams#last'
      get 'streams/:user/list' => 'streams#by_user'
      get 'streams/:id/show' => 'streams#show'
      get 'streams/:id/stop' => 'streams#stop'
      post 'streams/period' => 'streams#by_period'
      post 'streams/new' => 'streams#create'
      delete 'streams/:id/delete' => 'streams#delete'

      # RTMP Stat API
      get 'stats' => 'hdstat#stats'
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
