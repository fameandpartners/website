FameAndPartners::Application.routes.draw do
  get '/robots', to: 'robots#show', constraints: { format: /txt/ }

  scope '(:site_version)' do
    get 'sitemap_index', to: 'sitemaps#index', format: true, constraints: { format: /xml|xml.gz/ }
    get 'sitemap', to: 'sitemaps#show', format: true, constraints: { format: /xml|xml.gz/ }
  end

  match '/:site_version', to: 'index#show', constraints: { site_version: /(au)/ }

  get 'products.xml' => 'feeds#products', :defaults => { :format => 'xml' }
  get 'feed/products(.:format)' => 'feeds#products', :defaults => { :format => 'xml' }
  get 'simple_products.xml' => 'spree/products#index', :defaults => { :format => 'xml' }

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
    devise_for :user, class_name: Spree::User, skip: [:unlocks, :registrations, :passwords, :sessions, :omniauth_callbacks]
    devise_scope :user do
      get '/user/auth/facebook/callback' => 'spree/omniauth_callbacks#facebook'
    end
  end

  get '/us/*whatevs' => redirect(path: "/%{whatevs}")
  get '/us' => redirect("/")

  get '/prom/thanksbabe' => redirect('http://prom.fameandpartners.com?snapchat=true')
  get '/prom', :to => redirect { |params, request|
    if request.params.any?
      "http://prom.fameandpartners.com?#{request.params.to_query}"
    else
      "http://prom.fameandpartners.com"
    end
  }

  resources :user_campaigns, only: [:create] do
    collection do
      get  :check_state
    end
  end

  get '/undefined',    to: 'mysterious_route#undefined'
  get '/au/undefined', to: 'mysterious_route#undefined'
  get '/1000668',      to: 'mysterious_route#undefined'

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

  namespace :widgets do
    get 'main_nav' => 'site_navigations#main_nav'
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do

    get '/instagram/1' => 'statics#landing_page_mobile', :variant => '1'
    get '/instagram/2' => 'statics#landing_page_mobile', :variant => '2'
    get '/instagram/3' => 'statics#landing_page_mobile', :variant => '3'

    get '/fashionitgirl2015'  => 'statics#fashion_it_girl'
    get '/fashionitgirlau2015'  => 'statics#fashion_it_girl_au_2015'
    get '/fashionitgirlau2015/terms-and-conditions' => 'statics#fashion_it_girl_au_tc'

    get '/fashionitgirl2015-terms-and-conditions',  to: redirect('/')
    get '/nyfw-comp-terms-and-conditions',  to: redirect('/')
    get '/fashionitgirl2015-competition',  to: redirect('/')

    get '/feb_2015_lp' => 'statics#facebook_lp', :as => :feb_2015_lp
    get '/facebook-lp' => 'statics#facebook_lp', :as => :facebook_lp
    get '/fame2015',  to: redirect('/')

    # Redirecting collections (08/06/2015)
    get '/collection(/*anything)', to: redirect { |params, _| params[:site_version] ? "/#{params[:site_version]}/dresses" : '/dresses' }

    # Monday March 23 2015 TTL: 6 months
    get '/unidays' => 'statics#unidays_lp', :as => :unidays_lp

    get '/mystyle' => 'products/collections#show', :as => :mystyle_landing_page

    # Lookbooks
    # # Note: this 302 redirection is used on widgets, and it can change in the future. This should stay as a temporary redirection.
    # # Widgets are iframes, and every href have no follows.
    get '/lookbook' => redirect('/lookbook/the-luxe-collection', :status => 302), as: :lookbook

    get '/lookbook/jedi-cosplay' => redirect('/lookbook/make-a-statement')
    get '/lookbook/make-a-statement' => 'products/collections#show', :permalink => 'make-a-statement', :as => :make_a_statement_collection
    get '/lookbook/photo-finish' => 'products/collections#show', :permalink => 'photo-finish', :as => :photo_finish_collection
    get '/lookbook/the-luxe-collection' => 'products/collections#show', :permalink => 'luxe', :as => :luxe_collection

    get '/lookbook/garden-weeding' => redirect('/lookbook/garden-wedding')
    get '/lookbook/garden-wedding' => 'products/collections#show', :permalink => 'garden-party', :as => :garden_wedding_collection
    get '/here-comes-the-sun-collection' => redirect('/lookbook/here-comes-the-sun')

    get '/lookbook/here-comes-the-sun' => 'products/collections#show', :permalink => 'here-comes-the-sun', :as => :here_comes_the_sun_collection

    get '/lookbook/dance-hall-days' => 'products/collections#show', :permalink => 'dance-hall', :as => :dance_hall_days_collection

    get '/new-years-eve-dresses' => redirect('/lookbook/break-hearts')
    get '/break-hearts-collection' => redirect('/lookbook/break-hearts')
    get '/lookbook/break-hearts' => 'products/collections#show', :permalink => 'breakhearts', :as => :break_hearts_collection

    get '/sale-dresses' => redirect('/dresses/sale')
    get '/dresses/sale' => 'products/collections#show', :permalink => 'sale', :as => :sales_collection

    get '/rss/collections' => 'rss#collections', format: :rss, as: :collections_rss

    get '/bridesmaid-dresses' => 'statics#bridesmaid_lp', :as => :bridesmaid_collection

    get '/all-size' => redirect('/lookbook/all-size')
    get '/lookbook/all-size' => 'products/collections#show', :permalink => 'all-size', :as => :all_size_collection

    get '/prom-collection' => redirect('/lookbook/prom')
    get '/lookbook/prom' => 'products/collections#show', :permalink => 'PROM2015', :as => :prom_collection

    get '/lookbook/bohemian-summer' => 'products/collections#show', :permalink => 'bohemian-summer', :as => :bohemian_summer_collection

    get '/amfam'                  => redirect('/wicked-game-collection')
    get '/amfam-dresses'          => redirect('/wicked-game-collection')
    get '/wicked-game-collection' => 'statics#wicked_game', :as => :wicked_game_collection


    # A long tradition of hacking shit in.
    if Features.active?(:getitquick_unavailable)
      get '/getitquick' => 'hacky_messages#getitquick_unavailable', :as => :fast_making_dresses
    else
      get '/getitquick' => 'products/collections#show', defaults: { fast_making: true }, as: 'fast_making_dresses'
    end

    post '/shared/facebook' => 'competition/events#share'

    scope '/user_cart', module: 'user_cart' do
      root to: 'details#show', as: :user_cart_details

      get '/details'      => 'details#show'
      post '/promotion'   => 'promotions#create'

      post 'products' => 'products#create'
      delete 'products/:line_item_id' => 'products#destroy'
      delete 'products/:line_item_id/customizations/:customization_id' => 'products#destroy_customization'
      delete 'products/:line_item_id/making_options/:making_option_id' => 'products#destroy_making_option'
    end

    scope '/dresses' do
      root to: 'products/collections#show', as: :dresses
      get '/', to: 'products/collections#show', as: :collection

      # TODO - Remove? - 2015.04.11 - Redirecting old accessory and customisation style URLS to main product page.
      product_style_custom_redirect = -> path_params, _rq { ["/#{path_params[:site_version]}/dresses/dress-#{path_params[:product_slug]}", path_params[:color_name].presence].join('/') }
      get '/custom-:product_slug(/:color_name)',  to: redirect(product_style_custom_redirect)
      get '/styleit-:product_slug(/:color_name)', to: redirect(product_style_custom_redirect)

      # Colors should behave like query strings, and not paths
      get '/dress-:product_slug/:color' => redirect { |params, req| "/dresses/dress-#{params[:product_slug]}?#{req.params.except(:product_slug, :site_version).to_query}" }
      get '/dress-:product_slug' => 'products/details#show'
      get '/outerwear-:product_slug', to: 'products/details#show', as: :outerwear_details

      #roots categories
      get '/style',  to: redirect('/dresses')
      get '/style/:taxon', to: redirect('/dresses/%{taxon}')
      get '/event',  to: redirect('/dresses')
      get '/event/:taxon', to: redirect('/dresses/%{taxon}')
      get '/sale-(:sale)' => 'products/collections#show', as: 'dresses_on_sale'
      get '/*permalink' => 'products/collections#show', as: 'taxon'
    end

    # Custom Dresses
    get '/custom-dresses(/*whatever)',  to: redirect('/dresses')

    get '/celebrities',           to: redirect('/dresses')
    get '/celebrities/(:id)',     to: redirect('/dresses')
    get '/featured-bloggers/:id', to: redirect('/dresses')

    resource :product_variants, only: [:show]

    get '/lp/collection(/:collection)', to: redirect('/dresses')

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

    resource 'users/returns', as: 'user_returns', only: [:new, :create]

    get 'styleprofile' => 'users/styleprofiles#show', as: 'styleprofile'

    resources :wishlists_items, only: [:index, :create, :destroy], controller: 'users/wishlists_items' do
      get 'move_to_cart', on: :member
    end
    get 'wishlist' => 'users/wishlists_items#index', as: 'wishlist'
    get 'reviews' => 'users/reviews#index', as: 'reviews'
    # eo account settings

    resources :product_reservations, only: [:create]

    # Old Blog Redirection (30/06/2015)
    get '/blog(/*anything)', to: redirect('http://blog.fameandpartners.com')
  end

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
    # Static pages
    get '/about'   => 'statics#about', :as => :about_us
    get '/why-us'  => 'statics#why_us', :as => :why_us
    get '/team', to: redirect("http://www.fameandpartners.com/about")
    get '/terms'   => 'statics#ecom_terms'
    get '/privacy' => 'statics#ecom_privacy'
    get '/legal'   => 'statics#legal'
    get '/faqs'   => 'statics#faqs'
    get '/how-it-works', to: redirect("/why-us")
    get '/size-guide'  => 'statics#size_guide', :as => :size_guide

    get '/fashionista2014', to: redirect("/")
    get '/fashionista2014/info'   => 'statics#fashionista', :as => :fashionista_info
    get '/fashionista2014-winners'   => 'statics#fashionista_winner', :as => :fashionista_winner
    get '/compterms' => 'statics#comp_terms', :as => :competition_terms
    get '/plus-size',  to: redirect('/dresses/plus-size')

    namespace "campaigns" do
      resource :email_capture, only: [:create], controller: :email_capture
    end

    get '/fame-chain' => 'fame_chains#new'
    resource 'fame-chain', as: 'fame_chain', only: [:new, :create] do
      get 'success'
    end

    get '/style-consultation' => 'style_consultations#new'
    resource 'style-consultation', as: 'style_consultation', only: [:new, :create] do
      get 'success'
    end

    get '/styling-session'  => 'style_sessions#new', defaults: { session_type: 'default'  }
    get '/birthday-styling' => 'style_sessions#new', defaults: { session_type: 'birthday' }
    get '/prom-styling'     => 'style_sessions#new', defaults: { session_type: 'prom' }

    resource 'style-session', as: 'style_session', only: [:new, :create] do
      get 'success'
    end

    get '/wedding-consultation' => 'wedding_consultations#new'
    resource 'wedding-consultation', as: 'wedding_consultation', only: [:new, :create] do
      get 'success'
    end

    get '/contact' => 'contacts#new'
    resource 'contact', as: 'contact', only: [:new, :create] do
      get 'success'
    end

    # return form
    get '/returnsform', to: redirect('http://www.fameandpartners.com/assets/returnform.pdf')

    # External URLs
    get '/trendsetters', to: redirect('http://woobox.com/pybvsm')

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

    mount Spree::Core::Engine, at: '/'
  end

  namespace :admin do
    resources :bulk_order_updates, :except => [:edit]
    resources :fabric_cards, :only => [:index, :show] do
      resources :products, :only => [:show], controller: 'fabric_cards/products'
    end
    resources :fabrications,       :only => :update
    resources :shipments,          :only => :update
    resource  :sku_generation,     :only => [:show, :create]
    resources :dress_colours,      :only => :index
  end

  Spree::Core::Engine.routes.append do
    namespace :admin do
      resources :competition_participations, only: [:index], format: :csv
      scope 'products/:product_id', :as => 'product' do
        resource :style_profile, :controller => 'product_style_profile', :only => [:edit, :update]
      end

      post 'shipping_methods/update_positions' => "shipping_methods#update_positions"

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
        resources :moodboard_items do
          collection do
            post :update_positions, as: :update_positions
          end
        end

        resources :making_options, controller: 'product_making_options'

        resources :accessories, controller: 'product_accessories' do
          post :update_positions, on: :collection
        end
      end

      resource :styles, only: [:show, :update]

      get 'modals' => 'modals#index'

      get 'search/order_owners' => 'search#order_owners'
      get 'search/outerwear' => 'products#search_outerwear', as: :search_outerwear

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

    get 'search' => 'products/base#search'

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

    get '/express-delivery'  => 'products/collections#show', as: 'express_delivery', defaults: { order: 'fast_delivery' }

    # Redirecting all bridesmaid party URLs
    get '/bridesmaid-party(/*anything)' => redirect('/bridesmaid-dresses')

    resources :site_versions, only: [:show], as: :site_version
  end

  mount AdminUi::Engine, at: '/fame_admin'

  if Features.active?(:content_revolution)
    mount Revolution::Engine => "/"
  end
end
