FameAndPartners::Application.routes.draw do
  devise_for :spree_user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords',
                               :confirmations => 'spree/user_confirmations'},
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' }

  # Static pages for HTML markup
  match '/form' => 'pages#form'
  match '/posts' => 'pages#posts'
  match '/post' => 'pages#post'
  match '/celebrities' => 'pages#celebrities'
  match '/celebrity' => 'pages#celebrity'
  match '/competition'   => 'pages#competition'

  # Static pages
  get '/about'   => 'pages#about'
  get '/vision'  => 'pages#vision'
  get '/team'    => 'pages#team'
  get '/terms'   => 'pages#terms'
  get '/privacy' => 'pages#privacy'
  get '/legal'   => 'pages#legal'

  # MonkeyPatch for redirecting to Custom Dress page
  get '/fb_auth' => 'pages#fb_auth'

  resources :custom_dresses, :only => [:new, :create]
  resources :custom_dress_images, :only => [:create]

  root :to => 'pages#home'

  mount Spree::Core::Engine, at: '/'
end
