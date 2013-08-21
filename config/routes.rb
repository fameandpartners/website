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
    get '/account_settings' => 'spree/user_registrations#edit'
  end

  resources :line_items, only: [:create, :edit, :update, :destroy] do
    post 'move_to_wishlist', on: :member
  end

  resource :product_variants, only: [:show]

  scope '/collection' do
    root to: 'spree/products#index', as: 'collection'
    get '/:collection' => 'spree/products#index'
    get '/:collection/:id' => 'spree/products#show'
  end

  get 'products/:id/quick_view' => 'spree/products#quick_view'
  post 'products/:id/send_to_friend' => 'spree/products#send_to_friend'

  get 'search' => 'pages#search'

  get 'my-boutique' => 'pages#my_boutique', :as => :my_boutique

  # account settings
  resource :profile, only: [:show, :update], controller: 'users/profiles' do
    put 'update_image', on: :member
  end
  get 'user_orders' => 'users/orders#index', as: 'user_orders'
  get 'user_orders/:id' => 'users/orders#show', as: 'user_order'

  get 'styleprofile' => 'users/styleprofiles#show', as: 'styleprofile'

  resources :wishlists_items, only: [:index, :create, :destroy], controller: 'users/wishlists_items' do
    get 'move_to_cart', on: :member
  end
  get 'wishlist' => 'users/wishlists_items#index', as: 'wishlist'
  get 'reviews' => 'users/reviews#index', as: 'reviews'
  # eo account settings

  # Blog routes
  blog_constraint = lambda { |request|
    if Rails.env.development?
      request.host =~ /blog\.localdomain/
    elsif Rails.env.staging?
      request.host =~ /blog.fame.23stages.com/
    else
      request.host =~ /blog\.fameandpartners\.com/
    end
  }

  constraints blog_constraint do
    devise_for :spree_user,
               :class_name => 'Spree::User',
               :controllers => {:sessions => 'spree/user_sessions',
                                :registrations => 'spree/user_registrations',
                                :passwords => 'spree/user_passwords',
                                :confirmations => 'spree/user_confirmations',
                                :omniauth_callbacks => 'spree/omniauth_callbacks'
               },
               :skip => [:unlocks, :omniauth_callbacks],
               :path_names => {:sign_out => 'logout'} do
      get '/login' => 'spree/user_sessions#new'
      get '/signup' => 'spree/user_registrations#new'
      get '/logout' => 'spree/user_sessions#destroy'
    end

    get '/' => 'blog#index', as: :blog

    get '/about'   => 'blog#about', as: :about

    mount Spree::Core::Engine, at: '/'

    get '/celebrities' => 'blog/celebrities#index', as: :blog_celebrities
    get '/celebrities/photos' => 'blog/celebrities#index', as: :blog_celebrity_photos

    get '/celebrity/:slug/photos' => 'blog/celebrities#show', as: :blog_celebrity
    get '/celebrity/:slug/posts' => 'blog/celebrities#show', defaults: {type: 'posts'}, as: :blog_celebrity_posts

    post '/celebrity_photo/:id/like' => 'blog/celebrity_photos#like', as: :blog_celebrity_photo_like
    post '/celebrity_photo/:id/dislike' => 'blog/celebrity_photos#dislike', as: :blog_celebrity_photo_dislike

    get '/stylists' => 'blog/authors#index', as: :blog_authors
    get '/stylists/:stylist' => 'blog/authors#show', as: :blog_authors_post


    get '/red-carpet-events' => 'blog/posts#index', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_posts
    get '/red-carpet-events/:post_slug' => 'blog/posts#show', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_post


    get '/search/tags/:tag' => 'blog/searches#by_tag', as: :blog_search_by_tag
    get '/search' => 'blog/searches#by_query', as: :blog_search_by_query

    get '/:category_slug' => 'blog/posts#index', as: :blog_posts_by_category
    get '/:category_slug/:post_slug' => 'blog/posts#show', as: :blog_post_by_category

  end

  # Static pages
  get '/about'   => 'statics#about'
  get '/team'    => 'statics#team'
  get '/terms'   => 'statics#ecom_terms'
  get '/privacy' => 'statics#ecom_privacy'
  get '/legal'   => 'statics#legal'
  get '/faqs'   => 'statics#faqs'
  get '/how-it-works'   => 'statics#how_it_works', :as => :how_it_works 
  get '/trendsetter-program'   => 'statics#trendsetter_program', :as => :trendsetter_program 
  get '/custom-dresses'   => 'statics#custom_dresses', :as => :custom_dresses
  
  # External URLs
  get '/trendsetters', to: redirect('http://woobox.com/pybvsm')
  get '/workshops', to: redirect('http://www.fameandpartners.com/signup?workshop=true&utm_source=direct&utm_medium=direct&utm_term=workshop1&utm_campaign=workshops')
  
  

  # MonkeyPatch for redirecting to Custom Dress page
  get '/fb_auth' => 'pages#fb_auth'

  resources :custom_dresses, :only => [:create, :update] do
    collection do
      get :step1
    end
    member do
      get :step2
      put :success
    end
    resources :custom_dress_images, :only => [:create]
  end

  root :to => 'index#show'

  resource :competition, only: [:show] do
    post 'enter', on: :member
    get 'share(/:user_id)', on: :member, action: 'share', as: 'share'
    post 'invite', on: :member
    get 'stylequiz', on: :member
  end

  resource :quiz, :only => [:show] do
    resources :questions, :only => [:index, :show] do
      resource :answer, :only => [:create]
    end
  end

  scope '/users/:user_id', :as => :user do
    get '/style-report' => 'user_style_profiles#show', :as => :style_profile
    get '/style-report-debug' => 'user_style_profiles#debug'
    get '/recomendations' => 'user_style_profiles#recomendations'
  end

  get 'feed/products(.:format)' => 'feeds#products', :defaults => { :format => 'xml' }

  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.routes.append do
    namespace :admin do
      scope 'products/:product_id', :as => 'product' do
        resource :style_profile, :controller => 'product_style_profile', :only => [:edit, :update]
      end

      scope 'taxonomies/:taxonomy_id/taxons/:id' do
        resource :banner, only: [:update], as: :update_taxon_banner, controller: 'taxon_banners'
      end

      scope 'products/:product_id', :as => 'product' do
        resource :inspiration, :only => [:edit, :update]
      end

      match '/product_images/upload' => 'product_images#upload', as: 'upload_product_images'

      match '/blog' => redirect('/admin/blog/posts')
      namespace :blog do
        resources :promo_banners
        resources :categories
        resources :events

        resources :red_carpet_events, only: [:index] do
        end

        resources :assets, only: [:create, :destroy, :index]

        resources :post_photos
        resources :celebrity_photos do
          member do
            put :assign_celebrity
            put :assign_post
            put :make_primary
          end
        end

        resources :posts, only: [:new, :create, :edit, :update, :index, :destroy] do
          member do
            put :toggle_publish
            put :toggle_featured
          end
        end

        resources :red_carpet_events, only: [:new, :create, :edit, :update, :index, :destroy] do
          member do
            put :toggle_publish
          end
        end

        resources :celebrities do
          member do
            put :toggle_featured
          end
        end
      end
    end
  end
  match '/admin/blog/fashion_news' => 'posts#index', :via => :get, as: 'admin_blog_index_news'
  match '/blog/fashion_news' => 'posts#index', :via => :get, as: 'blog_index_news'
end
