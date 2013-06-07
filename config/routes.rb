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

  # Blog routes
  namespace :blog do
    get '/' => 'blog#index', action: :index
    [:celebrity_photos, :posts, :fashion_news, :prom_tips, :style_tips, :celebrities, :red_carpet_events].each do |crud|
      resources crud, only: [:index, :show]
    end
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

  root :to => 'pages#home'

  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.routes.append do
    namespace :admin do
      namespace :blog do
        [:celebrity_photos, :posts, :fashion_news, :prom_tips, :style_tips, :red_carpet_events].each do |crud|
          resources crud, except: [:show]
        end
        get '/' => 'blog#index', action: :index
      end
    end
  end

  match '/admin/blog/fashion_news' => 'fashion_news#index', :via => :get, as: 'admin_blog_index_news'

end
