FameAndPartners::Application.routes.draw do
  match '/:site_version', to: 'index#show', constraints: { site_version: /(us|au)/ }

  get 'products.xml' => 'feeds#products', :defaults => { :format => 'xml' }
  get 'feed/products(.:format)' => 'feeds#products', :defaults => { :format => 'xml' }

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
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
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
    get '/nyemix'   => 'statics#nyemix'

    # Custom Dresses part II
    scope '/custom-dresses', module: 'personalization' do
      get '/', to: 'registrations#new', as: :personalization
      post '/', to: 'registrations#create'

      get '/browse', to: 'products#index', as: :personalization_products
      get '/:permalink', to: 'products#show', as: :personalization_product
      get '/:permalink/style', to: 'products#style', as: :personalization_style_product
    end

    resources :celebrities, only: [:show]

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

    post '/product_personalizations' => 'product_personalizations#create', constraints: proc{ |request| request.format.js? }

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

    resources :product_reservations, only: [:create]
  end

  # Redirects from old blog urls
  constraints host: /blog\./ do
    get '/' => redirect(host: configatron.host, path: "/blog")
    match '*path' => redirect(host: configatron.host, path: "/blog/%{path}")
  end

  match '/blog(/*path)' => redirect(host: configatron.host, path: '/')

  # Blog routes
  scope '/blog' do
    get '/' => 'blog#index', as: :blog
    get '/about'   => 'blog#about', as: :about
    get '/rss' => 'blog/feeds#index', format: :rss, as: :blog_rss

    #get '/celebrities' => 'blog/celebrities#index', as: :blog_celebrities
    #get '/celebrities/photos' => 'blog/celebrities#index', as: :blog_celebrity_photos

    #get '/celebrity/:slug/photos' => 'blog/celebrities#show', as: :blog_celebrity
    #get '/celebrity/:slug/posts' => 'blog/celebrities#show', defaults: {type: 'posts'}, as: :blog_celebrity_posts

    #post '/celebrity_photo/:id/like' => 'blog/celebrity_photos#like', as: :blog_celebrity_photo_like
    #post '/celebrity_photo/:id/dislike' => 'blog/celebrity_photos#dislike', as: :blog_celebrity_photo_dislike

    get '/stylists' => 'blog/authors#index', as: :blog_authors
    get '/stylists/:stylist' => 'blog/authors#show', as: :blog_authors_post

    #get '/red-carpet-events' => 'blog/posts#index', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_posts
    #get '/red-carpet-events/:post_slug' => 'blog/posts#show', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_post

    get '/search/tags/:tag' => 'blog/searches#by_tag', as: :blog_search_by_tag
    get '/search' => 'blog/searches#by_query', as: :blog_search_by_query

    get '/:category_slug' => 'blog/posts#index', as: :blog_posts_by_category
    get '/:category_slug/:post_slug' => 'blog/posts#show', as: :blog_post_by_category

    get '/posts/:post_slug' => 'blog/posts#show', as: :blog_post
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do

    # Blogger static page
    get '/bloggers/racheletnicole' => 'statics#blogger'
    
    # Static pages
    get '/about'   => 'statics#about', :as => :about_us
    get '/why-us'  => 'statics#why_us', :as => :why_us
    get '/blake-lively'  => 'statics#blake-lively', :as => :blake_lively
    get '/team'    => 'statics#team'
    get '/terms'   => 'statics#ecom_terms'
    get '/privacy' => 'statics#ecom_privacy'
    get '/legal'   => 'statics#legal'
    get '/faqs'   => 'statics#faqs'
    get '/how-it-works'   => 'statics#how_it_works', :as => :how_it_works
    get '/trendsetter-program'   => 'statics#trendsetter_program', :as => :trendsetter_program
    get '/compterms' => 'statics#comp_terms'

    get '/campaigns/stylecall' => 'campaigns#show'
    post '/campaigns/stylecall' => 'campaigns#create'
    get '/campaigns/stylecall/thankyou' => 'campaigns#thank_you'
    post '/campaigns/dolly' => 'campaigns#dolly', as: :dolly_campaign
    post '/campaigns/newsletter' => 'campaigns#newsletter', as: :newsletter_campaign

    #get '/custom-dresses'   => 'custom_dress_requests#new',     :as => :custom_dresses
    #post '/custom-dresses'   => 'custom_dress_requests#create', :as => :custom_dresses_request

    get '/fame-chain' => 'fame_chains#new'
    resource 'fame-chain', as: 'fame_chain', only: [:new, :create] do
      get 'success'
    end

    # testing email
    get '/email/comp' => 'competition_mailer#marketing_email'

    # External URLs
    get '/trendsetters', to: redirect('http://woobox.com/pybvsm')
    get '/workshops', to: redirect('http://www.fameandpartners.com/%{site_version}/signup?workshop=true&utm_source=direct&utm_medium=direct&utm_term=workshop1&utm_campaign=workshops')
    
    # Fallen Product URL
    get '/thefallen', to: redirect("http://www.fameandpartners.com/%{site_version}/collection/Long-Dresses/the-fallen")
    get '/thefallendress', to: redirect("http://www.fameandpartners.com/%{site_version}collection/Long-Dresses/the-fallen")

    # MonkeyPatch for redirecting to Custom Dress page
    get '/fb_auth' => 'pages#fb_auth'

    root :to => 'index#show'

    resource :competition, only: [:show, :create] do
      post 'enter', on: :member, action: :create
      get 'share(/:user_id)', on: :member, action: 'share', as: 'share'
      post 'invite', on: :member
      get 'stylequiz', on: :member
    end

    resource :quiz, :only => [:show] do
      resources :questions, :only => [:index]
      resources :answers, :only => [:create]
    end

    scope '/users/:user_id', :as => :user do
      get '/style-report' => 'user_style_profiles#show', :as => :style_profile
      get '/style-report-debug' => 'user_style_profiles#debug'
      get '/recomendations' => 'user_style_profiles#recomendations'
    end

    mount Spree::Core::Engine, at: '/'
  end

  Spree::Core::Engine.routes.append do
    namespace :admin do
      scope 'products/:product_id', :as => 'product' do
        resource :style_profile, :controller => 'product_style_profile', :only => [:edit, :update]
      end

      scope 'taxonomies/:taxonomy_id/taxons/:id' do
        resource :banner, only: [:update], as: :update_taxon_banner, controller: 'taxon_banners'
      end

      resources :site_versions, only: [:index, :edit, :update]

      scope 'products/:product_id', :as => 'product' do
        resource :inspiration, :only => [:edit, :update]

        resource :colors, only: [:new, :create], controller: 'product_colors'
      end

      resource :product_uploads, only: [:new, :create, :show] do
        post :parse, on: :member, as: 'parse'
        get :preview, on: :member, as: 'preview'
      end

      match '/product_images/upload' => 'product_images#upload', as: 'upload_product_images'

      match '/blog' => redirect('/admin/blog/posts')

      get '/wishlist_items/download' => 'wishlist_items#download', as: 'wishlist_export'
      get '/user_style_profiles/download' => 'user_style_profiles#download', as: 'user_style_profiles_export'

      resources :competition_entries, only: [:index, :show]

      resource :product_positions, only: [:show, :create]

      resource :sale, :only => [:edit, :update]

      #resources :customisation_types do
      #  collection do
      #    post :update_positions
      #    post :update_values_positions
      #  end
      #end
      #delete '/customisation_values/:id', :to => "customisation_values#destroy", :as => :customisation_value

      #resources :products do
      #  resources :product_customisations
      #  resources :product_customisation_types, only: :destroy
      #  resources :product_customisation_values, only: :destroy
      #end
      resources :products do
        resource :customisation, only: [:show, :update], controller: 'product_customisations'
      end
      resources :customisation_values do
        post :update_positions, on: :collection
      end

      resources :products do
        resources :moodboard_items do
          collection do
            post :update_positions, as: :update_positions
          end
        end

        resources :accessories, controller: 'product_accessories' do
          post :update_positions, on: :collection
        end
      end

      resource :styles, only: [:show, :update]
      #resources :styles, only: [:index, :update] do
      #  resources :style_images, only: [:update]
      #end
      #delete '/styles/:style_name/style_images/:position', to: "style_images#destroy", as: :delete_style_image

      namespace :blog do
        resources :promo_banners
        resources :categories
        resources :events

        resources :red_carpet_events, only: [:index] do
        end

        resources :assets, only: [:create, :destroy, :index]

        resources :post_photos do
          put :make_primary, on: :member
        end

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

        resource :configuration, only: [:show, :update]
      end

      resources :celebrities, only: [:new, :create, :index, :edit, :update, :destroy] do
        scope module: :celebrity do
          resource :products, only: [:edit, :update]
          resource :style_profile, only: [:edit, :update]
          resources :images, only: [:index, :new, :create, :edit, :update, :destroy] do
            collection do
              post :update_positions
            end
          end
        end
      end
    end
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do

    get 'search' => 'pages#search'

    # Guest checkout routes
    resources :payment_requests, only: [:new, :create]
    namespace :guest do
      put '/checkout/update/:state', :to => 'checkout#update', :as => :update_checkout
      get '/checkout/thanks', :to => 'checkout#show' , :as => :checkout_thanks
      get '/checkout/:state', :to => 'checkout#edit', :as => :checkout_state
      get '/checkout/', :to => 'checkout#edit' , :as => :checkout

      post '/paypal', :to => 'paypal#express', :as => :paypal_express
      get '/paypal/confirm', :to => 'paypal#confirm', :as => :confirm_paypal
      get '/paypal/cancel', :to => 'paypal#cancel', :as => :cancel_paypal
      get '/paypal/notify', :to => 'paypal#notify', :as => :notify_paypal
    end

    match '/admin/blog/fashion_news' => 'posts#index', :via => :get, as: 'admin_blog_index_news'
    match '/blog/fashion_news' => 'posts#index', :via => :get, as: 'blog_index_news'

    # seo routes like *COLOR*-Dress
    get "(:colour)-Dresses" => 'spree/products#index', as: :colour_formal_dresses
  
    resources :site_versions, only: [:show]
  end

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end
end
