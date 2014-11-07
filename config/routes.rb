Rails.application.routes.draw do


  match '/auth/:provider/callback' => 'users#login', via: [:get, :post]
  get 'auth_session' => 'application#session_auth'
  get '/logout' => 'users#logout'

  get 'home' => 'home#cabinet'

  get 'channel/live' => 'streams#get_live'
  get 'channel/all' => 'streams#get_all'
  get 'channel/:channel' => 'streams#get_channel'

  get '/auth_stream' => 'nginx#get_key'
  get 'incr_stream' => 'nginx#increase_viewer_count'
  get 'decr_stream' => 'nginx#decrease_viewer_count'
  get 'channel/move_record' => 'nginx#move_record'
  get 'end_cinema' => 'nginx#end_cinema'

  get '/home/remake_key' => 'home#remake_key'
  get 'guestroom' => 'home#guest_room'

  get 'faq' => 'home#faq'
  get 'faq-irc' => 'home#faq_irc'

  post 'home/make_key' => 'home#make_key'
  post 'home/change_key' => 'home#change_key'

  post 'home/channel/new' => 'channels#new'
  post 'home/channel/edit' => 'channels#edit'
  post 'home/channel/delete' => 'channels#delete'

  post 'home/tweet' => 'home#tweet'

  get 'staff' => 'staff#index'

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
