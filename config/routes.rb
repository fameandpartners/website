FameAndPartners::Application.routes.draw do
  devise_for :spree_user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords',
                               :confirmations => 'spree/user_confirmations',
                               :omniauth_callbacks => 'spree/omniauth_callbacks'
             },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' }

  devise_scope :spree_user do
    get '/spree_user/thanks' => 'spree/user_registrations#thanks'
  end

  resources :line_items, only: [:create, :edit, :update, :destroy]
  get 'products/:id/quick_view' => 'spree/products#quick_view'

  # Static pages for HTML markup
  match '/posts' => 'pages#posts'
  match '/post' => 'pages#post'
  match '/celebrities' => 'pages#celebrities'
  match '/celebrity' => 'pages#celebrity'
  match '/competition'   => 'pages#competition'
  match '/custom-made-dresses' => 'pages#custom_made_dresses'

  # Static for ecommerce
  #match '/home' => 'pages#home'
  #match '/products' => 'pages#products'
  match '/account' => 'pages#account'
  match '/orders' => 'pages#orders'
  match '/order' => 'pages#order'
  match '/styleprofile' => 'pages#styleprofile'
  match '/reviews' => 'pages#reviews'
  match '/wishlist' => 'pages#wishlist'
  match '/product' => 'pages#product'
  #match '/cart' => 'pages#cart'
  #match '/quick-view' => 'pages#quick-view'
  #match '/browse' => 'pages#browse'
  #match '/checkout' => 'pages#checkout'

  # Static pages
  get '/about'   => 'statics#about'
  get '/team'    => 'statics#team'
  get '/terms'   => 'statics#terms'
  get '/privacy' => 'statics#privacy'
  get '/legal'   => 'statics#legal'
  get '/how-it-works'   => 'statics#how_it_works', :as => :how_it_works

  # MonkeyPatch for redirecting to Custom Dress page
  get '/fb_auth' => 'pages#fb_auth'

  resources :custom_dresses, :only => [:new, :create, :update] do
    resources :custom_dress_images, :only => [:create]
  end

  root :to => 'index#show'

  mount Spree::Core::Engine, at: '/'
end
