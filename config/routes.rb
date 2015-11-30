Rails.application.routes.draw do

  #Root
  root 'home#index'
  get 'home/login' => 'home#login'
  get 'home/' => 'home#cabinet'
  get 'home/faq' => 'home#faq'
  get 'home/admin' => 'home#admin'

  #auth
  # get 'auth_session' => 'application#session_auth' #why I even need this
  match '/auth/:provider/callback' => 'users#login', via: [:get, :post]
  get 'logout' => 'users#logout'

  #Channel API
  get 'channel/live' => 'channels#list_live', defaults: {page: 0}
  get 'channel/all' => 'channels#list_all', defaults: {page: 0}
  get 'channel/:service/:channel' => 'channels#show'
  get 'service/:service' => 'channels#list_service_channels', defaults: {service: "hd"}
  post 'channel/new' => 'channels#new'
  post 'channel/update' => 'channels#update'

  #User API
  get 'user/:twitter_id' => 'users#show'
  get 'user/:twitter_id/videos' => 'users#videos'
  post 'user/:twitter_id/update' => 'users#update'
  post 'user/:twitter_id/grant' => 'users#grant'

  match 'user/guest/auth' => 'users#guest_in', via: [:get, :post]
  get 'user/guest/videos' => 'user#guest_video'

  #Key API
  get 'auth_stream' => 'keys#auth'
  post 'keys/create' => 'keys#create'
  post 'keys/expire' => 'keys#expire'
  post 'keys/update' => 'keys#update'


  #Video API
  get 'video' => 'videos#index'
  post 'video/:id/save' => 'videos#save'
  delete 'video' => 'videos#remove'

  #Pages:

  #bitdash
  get 'bitdash/:channel' => 'channels#bitdash', defaults: {channel: "records"}
  get 'bitdash' => 'channels#bitdash'

#avconv -re -i /home/prails/Downloads/stream.flv -f flv rtmp://localhost:1935/live/omckws?key=50adf9fc-8499-4d45-b499-de831586cd9a
=begin
    #Auth
    match '/auth/:provider/callback' => 'users#login', via: [:get, :post]
    get 'auth_session' => 'application#session_auth'
    get 'logout' => 'users#logout'
    #post 'home/manage_perm' => 'users#manage_perm'
    #post 'home/remove_streamer' => 'users#remove_streamer'

    #Old Home
    #get 'home' => 'staff#index'

    #API
    get 'channel/move_record' => 'nginx#move_record'
    get 'channel/live' => 'streams#get_live'
    get 'channel/all' => 'streams#get_all'
    get 'channel/:service/:channel' => 'streams#get_channel'

    #bitdash
    get 'bitdash/:channel' => 'channels#bitdash'
    get 'bitdash' => 'channels#bitdash'

    #NGINX Controller
    get 'auth_stream' => 'nginx#get_key'
    post 'auth_stream' => 'nginx#get_key'
    get 'incr_stream' => 'nginx#increase_viewer_count'
    get 'decr_stream' => 'nginx#decrease_viewer_count'
    get 'end_cinema' => 'nginx#end_cinema'

    #Keys
    get 'home/remake_key' => 'keys#remake_key'
    post 'home/make_key' => 'keys#make_key'
    post 'home/change_key' => 'keys#change_key'
    post 'home/expire_key' => 'keys#expire_key'

    #Pages
    get 'faq' => 'home#faq'
    get 'faq-irc' => 'home#faq_irc'
    get 'guest' => 'home#guest'
    post 'guest' => 'home#guest'

    #Channel CRUD
    post 'home/channel/new' => 'channels#new'
    post 'home/channel/edit' => 'channels#edit'
    post 'home/channel/delete' => 'channels#delete'

    #Tweet Controller
    post 'home/tweet' => 'tweets#tweet'

    #Video
    get 'user/vids' => 'videos#list'
    get 'user/vids/check' => 'videos#check_deleted'
    delete 'user/vids/delete' => 'videos#delete'
=end

end
