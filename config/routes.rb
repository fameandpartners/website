FameAndPartners::Application.routes.draw do
  get '/robots', to: 'robots#show', constraints: { format: /txt/ }

  match '/:site_version', to: 'index#show', constraints: { site_version: /(au)/ }

  get 'products.xml' => 'feeds#products', :defaults => { :format => 'xml' }
  get 'feed/products(.:format)' => 'feeds#products', :defaults => { :format => 'xml' }
  get 'simple_products.xml' => 'spree/products#index', :defaults => { :format => 'xml' }

  get '/us/*whatevs' => redirect(path: "/%{whatevs}")
  get '/us' => redirect("/")


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

    # MonkeyPatch for store params & redirect to custom page
    get '/fb_auth' => 'spree/omniauth_facebook_authorizations#fb_auth'
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
    get '/fashionitgirl2015'  => 'statics#fashion_it_girl'
    get '/fashionitgirl2015-terms-and-conditions',  to: redirect('/')
    get '/nyfw-comp-terms-and-conditions',  to: redirect('/')
    get '/fashionitgirl2015-competition',  to: redirect('/')

    get '/bridesmaid-dresses' => 'statics#bridesmaid_lp', :as => :bridesmaid_lp
    get '/feb_2015_lp' => 'statics#facebook_lp', :as => :feb_2015_lp
    get '/facebook-lp' => 'statics#facebook_lp', :as => :facebook_lp
    get '/sale-dresses' => 'statics#sale', :as => :sale
    get '/fame2015',  to: redirect('/')


    # Monday March 23 2015 TTL: 6 months
    get '/unidays' => 'statics#unidays_lp', :as => :unidays_lp

    #edits
    get '/new-years-eve-dresses' => redirect('/break-hearts-collection')
    get '/break-hearts-collection' => 'statics#break_hearts_not_banks', :as => :break_hearts_collection

    get '/amfam' => redirect('/amfam-collection')
    get '/amfam-dresses'  => redirect('/amfam-collection')
    get '/wicked-game-collection' => 'statics#wicked_game', :as => :wicked_game_collection

    # get '/prom' => 'statics#prom_lp', :as => :prom_lp
    get '/prom' => redirect('http://prom.fameandpartners.com')
    get '/prom/thanksbabe' => redirect('http://prom.fameandpartners.com?snapchat=true')

    get '/prom-collection' => 'statics#prom', :as => :prom_collection
    get '/bridesmaid-dresses' => 'statics#bridesmaid_lp', :as => :bridesmaid_collection

    post '/shared/facebook' => 'competition/events#share'

    scope '/user_cart', module: 'user_cart' do
      root to: 'details#show', as: :user_cart_details

      get '/details'      => 'details#show'
      post '/promotion'   => 'promotions#create'

      resources :products, only: [:create, :edit, :update, :destroy]
    end

    scope '/dresses' do
      root to: 'products/collections#show', as: :dresses

      # TODO - Remove? - 2015.04.11 - Redirecting old accessory and customisation style URLS to main product page.
      product_style_custom_redirect = -> path_params, _rq { ["/#{path_params[:site_version]}/dresses/dress-#{path_params[:product_slug]}", path_params[:color_name].presence].join('/') }
      get '/custom-:product_slug(/:color_name)',  to: redirect(product_style_custom_redirect)
      get '/styleit-:product_slug(/:color_name)', to: redirect(product_style_custom_redirect)


      get '/dress-:product_slug(/:color_name)' => 'products/details#show'
      #roots categories
      get '/style',  to: redirect('/dresses')
      get '/event',  to: redirect('/dresses')
      get '/body-shape' => 'spree/products#root_taxon', defaults: {taxon_root: 'bodyshape'}
      get '/colour',  to: redirect('/dresses')
      get '/color',  to: redirect('/dresses')

      get '/:event/:style' => 'spree/products#index'
      get '/sale-(:sale)' => 'products/collections#show', as: "dresses_on_sale"
      get '/*permalink' => 'products/collections#show', as: 'taxon'
      get 't/*id', :to => 'taxons#show', :as => :dress_nested_taxons
    end


    # to correctly redirect, we should know product taxon or extract collection from param
    get "/products"             => 'redirects#products_index'
    get "/products/:product_id" => 'redirects#products_show'
    get "/products/:collection/:product_id" => 'redirects#products_show'

    # Custom Dresses part II
    scope '/custom-dresses' do
      get '/', to: 'registrations#new', as: :personalization
      post '/', to: 'registrations#create'

      get '/browse', to: 'products#index', as: :personalization_products
      get '/:permalink', to: 'redirects#products_show', as: :personalization_product, defaults: {custom_dress: true}
      get '/:permalink/style', to: 'redirects#products_show', as: :personalization_style_product, defaults: {style_dress: true}
    end

    get '/celebrities',  to: redirect('/dresses')
    get '/celebrities/:id' => 'celebrities#show', as: 'celebrity', defaults: { lp: 'celebrity' }
    get '/featured-bloggers/:id' => 'celebrities#show', as: 'featured_blogger'

    resource :product_variants, only: [:show]

    scope '/collection' do
      root to: 'redirects#products_index', as: 'collection'
      get '/:collection/:product_id' => 'redirects#products_show'
      get '/:collection' => 'redirects#products_index'
    end

    get '/lp/collection(/:collection)' => 'spree/products#index', defaults: { lp: 'lp' }

    get '/quick_view/:id' => 'spree/products#quick_view'
    post 'products/:id/send_to_friend' => 'spree/products#send_to_friend'

    get 'my-boutique' => 'boutique#show', :as => :my_boutique
    get 'my-boutique/:user_id' => 'boutique#show', :as => :user_boutique
    get 'my-boutique/:user_id/:competition_id' => 'boutique#show', :as => :user_competition_boutique

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

  # Blog routes
  scope "(/:site_version)/blog", constraints: { site_version: /(us|au)/ } do
    get '/' => 'blog#index', as: :blog
    get '/about'   => 'blog#about', as: :about
    get '/rss' => 'blog/feeds#index', format: :rss, as: :blog_rss

    get '/stylists' => 'blog/authors#index', as: :blog_authors
    get '/stylists/:stylist' => 'blog/authors#show', as: :blog_authors_post

    get '/red-carpet-events' => 'blog/posts#index', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_posts
    get '/red-carpet-events/:post_slug' => 'blog/posts#show', defaults: {type: 'red_carpet'}, as: :blog_red_carpet_post

    get '/search/tags/:tag' => 'blog/searches#by_tag', as: :blog_search_by_tag
    get '/search' => 'blog/searches#by_query', as: :blog_search_by_query

    get '/:category_slug' => 'blog/posts#index', as: :blog_posts_by_category
    get '/:category_slug/:post_slug' => 'blog/posts#show', as: :blog_post_by_category

    get '/posts/:post_slug' => 'blog/posts#show', as: :blog_post
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do

    # Blogger static page
    get '/bloggers/liz-black', to: redirect("/")
    get '/bloggers/ren' => 'statics#blogger_ren', as: :racheletnicole
    get '/dani-stahl', to: redirect("/")

    # Static pages
    get '/about'   => 'statics#about', :as => :about_us
    get '/why-us'  => 'statics#why_us', :as => :why_us
    get '/team', to: redirect("http://www.fameandpartners.com/about")
    get '/terms'   => 'statics#ecom_terms'
    get '/privacy' => 'statics#ecom_privacy'
    get '/legal'   => 'statics#legal'
    get '/faqs'   => 'statics#faqs'
    get '/how-it-works', to: redirect("/why-us")
    get '/fashionista2014', to: redirect("/")
    get '/fashionista2014/info'   => 'statics#fashionista', :as => :fashionista_info
    get '/fashionista2014-winners'   => 'statics#fashionista_winner', :as => :fashionista_winner
    get '/compterms' => 'statics#comp_terms', :as => :competition_terms
    get '/plus-size',  to: redirect('/dresses')

    namespace "campaigns" do
      resource :newsletter, only: [:new, :create], controller: :newsletter
      resource :email_capture, only: [:new, :create], controller: :email_capture
    end

    get '/custom-dresses'   => 'custom_dress_requests#new',     :as => :custom_dresses
    post '/custom-dresses'   => 'custom_dress_requests#create', :as => :custom_dresses_request

    get '/fame-chain' => 'fame_chains#new'
    resource 'fame-chain', as: 'fame_chain', only: [:new, :create] do
      get 'success'
    end

    get '/style-consultation' => 'style_consultations#new'
    resource 'style-consultation', as: 'style_consultation', only: [:new, :create] do
      get 'success'
    end

    # return form
    get '/returnsform', to: redirect('http://www.fameandpartners.com/assets/returnform.pdf')

    # External URLs
    get '/trendsetters', to: redirect('http://woobox.com/pybvsm')
    get '/workshops', to: redirect('http://www.fameandpartners.com/%{site_version}/signup?workshop=true&utm_source=direct&utm_medium=direct&utm_term=workshop1&utm_campaign=workshops')

    # Fallen Product URL
    get '/thefallen', to: redirect("http://www.fameandpartners.com/%{site_version}/collection/Long-Dresses/the-fallen")
    get '/thefallendress', to: redirect("http://www.fameandpartners.com/%{site_version}collection/Long-Dresses/the-fallen")

    root :to => 'index#show'

    # style quiz
    #resource :quiz, :only => [:show] do
    #  resources :questions, :only => [:index]
    #  resources :answers, :only => [:create]
    #end
    resource :style_quiz, only: [:show, :update], controller: 'style_quiz'
    resource :style_profile, only: [:show], controller: 'style_profiles'

    scope '/users/:user_id', :as => :user do
      get '/style-report' => 'user_style_profiles#show', :as => :style_profile
      get '/style-report-debug' => 'user_style_profiles#debug'
      get '/recomendations' => 'user_style_profiles#recomendations'
    end

    # Redirects for old pages as part of SEO
    match '/competition/' => redirect('/')
    match '/competition/*all' => redirect('/')

    match "/gregg-sulkin" => redirect('/')

    match '/trendsetter-program' => redirect('/')

    match '/bloggers/racheletnicole' => redirect('/bloggers/ren')
    match '/rachelxnicole' => redirect('/renxfame')

    match '/blog/celebrity/*all' => redirect('/blog')

    match '/blog/au/site_versions/au' => redirect('/blog')
    match '/blog/au/site_versions/us' => redirect('/blog')


    mount Spree::Core::Engine, at: '/'
  end

  Spree::Core::Engine.routes.append do
    namespace :admin do
      resources :competition_participations, only: [:index], format: :csv
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

        resources :videos, except: [:show], controller: 'product_videos' do
          post :update_positions, on: :collection
        end
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

      resource :product_positions, only: [:show, :create, :update]

      put 'sales/reset_cache' => 'sales#reset_cache'
      resources :sales, :except => [:show]

      # stock invent settings
      get 'stock_invent'                => 'stock_invent#edit',          as: :stock_invent
      put 'stock_invent'                => 'stock_invent#update'
      get 'stock_invent/status'         => 'stock_invent#status',        as: :stock_invent_status
      get 'stock_invent/auth'           => 'stock_invent#google_auth',   as: :stock_invent_access_token_request
      get 'stock_invent/auth_callback'  => 'stock_invent#auth_callback', as: :stock_invent_google_auth_callback

      resources :products do
        resources :customisation_values
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

      get 'modals' => 'modals#index'

      namespace :blog do
        resources :promo_banners
        resources :categories
        resources :events

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
          resources :moodboard_items do
            post :update_positions, as: :update_positions, on: :collection
          end
          resources :accessories, controller: 'product_accessories' do
            post :update_positions, on: :collection
          end

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

    get 'search' => 'products/search_results#show'

    # Guest checkout routes
    resources :payment_requests, only: [:new, :create]
    namespace :guest do
      put '/checkout/update/:state', :to => 'spree/checkout#update', :as => :update_checkout
      get '/checkout/thanks', :to => 'spree/checkout#show' , :as => :checkout_thanks
      get '/checkout/:state', :to => 'spree/checkout#edit', :as => :checkout_state
      get '/checkout/', :to => 'spree/checkout#edit' , :as => :checkout

      post '/paypal', :to => 'paypal#express', :as => :paypal_express
      get '/paypal/confirm', :to => 'paypal#confirm', :as => :confirm_paypal
      get '/paypal/cancel', :to => 'paypal#cancel', :as => :cancel_paypal
      get '/paypal/notify', :to => 'paypal#notify', :as => :notify_paypal
    end

    match '/admin/blog/fashion_news' => 'posts#index', :via => :get, as: 'admin_blog_index_news'
    match '/blog/fashion_news' => 'posts#index', :via => :get, as: 'blog_index_news'

    # seo routes like *COLOR*-Dress
    get "(:colour)-Dresses" => 'products/collections#show', as: :colour_formal_dresses

    # seo route
    get "new-collection" => "products/collections#show", as: :new_collection

    get '/next-day-delivery' => redirect('/express-delivery')
    get '/express-delivery'  => 'products/collections#show', as: 'express_delivery', defaults: { order: 'fast_delivery' }

    scope '/bridesmaid-party', module: 'bridesmaid' do
      root to: 'landings#bride', as: :bridesmaid_party
      get '/info'     => 'details#edit',   as: :bridesmaid_party_info
      put '/info'     => 'details#update'
      get '/colour'   => 'colours#edit',   as: :bridesmaid_party_colour
      put '/colour'   => 'colours#update'
      get '/concierge_service'  => 'additional_products#new',  as: :bridesmaid_party_consierge_service
      post '/additional_products(/:product)' => 'additional_products#create'
      get '/dresses'  => 'products#index', as: :bridesmaid_party_dresses
      get '/dresses/dress-:product_slug(/:color_name)' => 'products#show', as: :bridesmaid_party_dress
      get '/moodboard(/:user_slug)' => 'moodboard#show', as: :bridesmaid_party_moodboard
      get '/:user_slug/dress-:product_slug(/:color_name)' => 'product_details#show', as: :bridesmaid_party_dress_details
      put '/:user_slug/dress-:product_slug(/:color_name)' => 'selected_products#update', as: :bridesmaid_dress_selection
      get '/:user_slug' => 'landings#bridesmaid', as: :bridesmaid_signup
      post 'selected_product/:id/add_to_cart' => 'selected_products#add_to_cart', as: :bridesmaid_add_for_bridesmaid

      post '/share' => 'memberships#create'
    end

    resources :site_versions, only: [:show]
  end

  if Rails.env.development?
    mount MailPreview => 'mail_view'

    #require 'sidekiq/web'
    #mount Sidekiq::Web => '/sidekiq'
  end
end
