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
