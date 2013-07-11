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
      request.host =~ /blog\.#{Regexp.escape(configatron.host)}/
    end
  }

  constraints blog_constraint do
    devise_for :spree_user,
               :class_name => 'Spree::User',
               :controllers => { :sessions => 'spree/user_sessions',
                                 :registrations => 'spree/user_registrations',
                                 :passwords => 'spree/user_passwords',
                                 :confirmations => 'spree/user_confirmations',
                                 :omniauth_callbacks => 'spree/omniauth_callbacks'
               },
               :skip => [:unlocks, :omniauth_callbacks],
               :path_names => { :sign_out => 'logout' } do
        get '/login' => 'spree/user_sessions#new'
        get '/signup' => 'spree/user_registrations#new'
        get '/logout' => 'spree/user_sessions#destroy'
     end

     get '/' => 'blog#index', as: :blog

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

  root :to => 'pages#home'

  mount Spree::Core::Engine, at: '/'

  Spree::Core::Engine.routes.append do
    namespace :admin do
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
            put :make_primary
          end
        end

        resources :posts, only: [:new, :create, :edit, :update, :index, :destroy] do
          member do
            put :toggle_publish
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
