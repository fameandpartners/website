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

  # Static pages for HTML markup
  match '/posts' => 'pages#posts'
  match '/post' => 'pages#post'
  match '/celebrities' => 'pages#celebrities'
  match '/celebrity' => 'pages#celebrity'
  match '/competition'   => 'pages#competition'
  match '/custom-made-dresses' => 'pages#custom_made_dresses'

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

  resource :quiz, :only => [:show] do
    resources :questions, :only => [:index]
    resource :question, :only => [:show] do
      resource :answer, :only => [:create]
    end

    member do
      get  :report
      get  :thanks
    end
  end

  root :to => 'pages#home'

  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.routes.append do
    namespace :admin do
      scope 'products/:product_id', :as => 'product' do
        resource :style_profile, :controller => 'product_style_profile', :only => [:edit, :update]
      end
    end
  end
end
