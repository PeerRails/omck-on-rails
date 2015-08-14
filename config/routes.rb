Rails.application.routes.draw do

  #Auth
  match '/auth/:provider/callback' => 'users#login', via: [:get, :post]
  get 'auth_session' => 'application#session_auth'
  get 'logout' => 'users#logout'
  post 'home/manage_perm' => 'users#manage_perm'
  post 'home/remove_streamer' => 'users#remove_streamer'

  #Old Home
  get 'home' => 'staff#index'

  #API
  get 'channel/move_record' => 'nginx#move_record'
  get 'channel/live' => 'streams#get_live'
  get 'channel/all' => 'streams#get_all'
  get 'channel/:service/:channel' => 'streams#get_channel'

  #bitdash
  get 'bitdash/:channel' => 'channels#bitdash'

  #NGINX Controller
  get 'auth_stream' => 'nginx#get_key'
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
  post 'user/vids/delete' => 'videos#delete'

  #Root
  root 'home#index'

  #resources :keys
  #resources :tweets

  #avconv -re -i /home/prails/Downloads/stream.flv -f flv rtmp://localhost:1935/live/omckws?key=50adf9fc-8499-4d45-b499-de831586cd9a

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
