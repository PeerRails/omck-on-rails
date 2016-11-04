Rails.application.routes.draw do

  # Root
  root :to => 'frontpage#index'
  get 'player' => 'frontpage#player'
  get 'faq' => 'frontpage#faq'

  # Authorization
  get 'login' => 'session#login'
  post 'login' => 'session#enter'
  post 'register' => 'session#register'
  get 'logout' => 'session#logout'

  get 'verify_email' => 'session#verify'
  get 'forgot_password' => 'session#forgot_password'
  post 'restore_password' => 'session#restore_password'

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

      get 'stats' => 'hdstat#stats'
    end
  end
end
