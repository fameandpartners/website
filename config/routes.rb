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

  # Blog routes
  blog_constraint = lambda { |request|
    if Rails.env.development?
      request.host =~ /blog\.localdomain/
    else
      request.host =~ /blog\.#{configatron.application.hostname}/
    end
  }

  constraints blog_constraint do
     get '/' => 'blog#index', as: :blog
     get '/celebrities' => 'blog/celebrities#index', as: :blog_celebrities
     get '/celebrities_photos' => 'blog/celebrities#index', as: :blog_celebrity_photos
     get '/celebrity/:slug' => 'blog/celebrities#show', as: :blog_celebrity
     get '/red-carpet-events' => 'blog/posts#index', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_posts
     get '/red-carpet-events/:post_slug' => 'blog/posts#show', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_post
     get '/stylists' => 'blog/authors#index', as: :blog_authors
     get '/stylists/:stylist' => 'blog/authors#index', as: :blog_authors_post
     get '/search/tags/:tag' => 'blog/searches#by_tag', as: :blog_search_by_tag
     get '/search/authors/:author_slug' => 'blog/searches#by_tag', as: :blog_search_by_author
     get '/search/events/:event' => 'blog/searches#by_event', as: :blog_search_by_event
     get '/search' => 'blog/searches#by_query', as: :blog_search_by_query
     get '/:category_slug' => 'blog/posts#index', as: :blog_posts_by_category
     get '/:category_slug/:post_slug' => 'blog/posts#show', as: :blog_post_by_category
  end

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

  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.routes.append do
    namespace :admin do
      match '/blog' => redirect('/admin/blog/promo_banners')
      namespace :blog do
        resources :promo_banners
        resources :categories
        resources :events
        resources :authors
        resources :posts do
          resources :post_photos
          resources :celebrity_photos
        end
        resources :celebrities do
          resources :celebrity_photos
        end
      end
    end
  end

  match '/admin/blog/fashion_news' => 'posts#index', :via => :get, as: 'admin_blog_index_news'
  match '/blog/fashion_news' => 'posts#index', :via => :get, as: 'blog_index_news'


end
