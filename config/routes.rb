FameAndPartners::Application.routes.draw do

  ############################
  # Devise Omniauth Workaround
  ############################
  # This is needed to make Facebook Login work.
  # Since we're redirecting every /us/* URL, facebook callback is being redirected twice
  devise_scope :spree_user do
    get '/us/user/auth/facebook/callback' => 'spree/omniauth_callbacks#facebook'
  end

  ########################
  # US Redirection to root
  ########################
  get '/us/*whatevs', to: redirect(path: "/%{whatevs}")
  get '/us' => redirect('/')

  #######################################################
  # Temporary redirection to fix wrong path sent to users
  #######################################################

  # TODO: (May 26 2016) Every redirection on this block should live in the HTTP server and not in the application!

  get '/AU' => redirect(path: '/au/dresses')

  if Features.active?(:redirect_to_com_au_domain)
    get '/au/*whatevs' => redirect(path: '/%{whatevs}', host: 'www.fameandpartners.com.au')
    get '/au' => redirect(path: '/', host: 'www.fameandpartners.com.au')
  end

  if Features.active?(:redirect_to_www_and_https)
    constraints(host: /^fameandpartners.com.au/) do
      root to: redirect('https://www.fameandpartners.com.au')
      match '/*path', to: redirect { |_, request| URI.join('https://www.fameandpartners.com.au', request.fullpath).to_s }
    end

    constraints(host: /^fameandpartners.com/) do
      root to: redirect('https://www.fameandpartners.com')
      match '/*path', to: redirect { |_, request| URI.join('https://www.fameandpartners.com', request.fullpath).to_s }
    end
  end

  # TODO: After .com.au migration, this scope can simply go away.
  scope '(:site_version)', constraints: { site_version: /(us|au)/ } do
    ##########
    # Sitemaps
    ##########
    get 'sitemap_index', to: 'sitemaps#index', format: true, constraints: { format: /xml|xml.gz/ }
    get 'sitemap', to: 'sitemaps#show', format: true, constraints: { format: /xml|xml.gz/ }

    ##############################
    # Devise & User authentication
    ##############################
    devise_for :spree_user,
               class_name:  'Spree::User',
               controllers: { sessions:           'spree/user_sessions',
                              registrations:      'spree/user_registrations',
                              passwords:          'spree/user_passwords',
                              confirmations:      'spree/user_confirmations',
                              omniauth_callbacks: 'spree/omniauth_callbacks'
               },
               skip:        [:unlocks, :omniauth_callbacks],
               path_names:  { sign_out: 'logout' }

    devise_scope :spree_user do
      get '/user/auth/facebook/callback' => 'spree/omniauth_callbacks#facebook'
      get '/spree_user/thanks' => 'spree/user_registrations#thanks'
      get '/account_settings' => 'spree/user_registrations#edit'
    end

    # MonkeyPatch for store params & redirect to custom page
    get '/fb_auth' => 'spree/omniauth_facebook_authorizations#fb_auth'

    ##############
    # Static Pages
    ##############
    # Legacy marketing campaign
    # get '/instagram/1' => 'statics#landing_page_mobile', variant: '1'
    # get '/instagram/2' => 'statics#landing_page_mobile', variant: '2'
    # get '/instagram/3' => 'statics#landing_page_mobile', variant: '3'

    get '/fashionitgirl2015' => 'statics#fashion_it_girl'
    get '/fashionitgirlau2015' => 'statics#fashion_it_girl_au_2015'
    get '/fashionitgirlau2015/terms-and-conditions' => 'statics#fashion_it_girl_au_tc'

    get '/fashionitgirl2015-terms-and-conditions', to: redirect('/')
    get '/nyfw-comp-terms-and-conditions', to: redirect('/')
    get '/fashionitgirl2015-competition', to: redirect('/')

    get '/feb_2015_lp' => 'statics#facebook_lp', :as => :feb_2015_lp
    get '/facebook-lp' => 'statics#facebook_lp', :as => :facebook_lp
    get '/fame2015', to: redirect('/')

    # Redirecting collections (08/06/2015)
    get '/collection(/*anything)', to: redirect { |params, _| params[:site_version] ? "/#{params[:site_version]}/dresses" : '/dresses' }

    # Monday March 23 2015 TTL: 6 months
    get '/unidays' => 'statics#unidays_lp', :as => :unidays_lp

    get '/mystyle' => 'products/collections#show', :as => :mystyle_landing_page

    # Partners In Crime Sweepstakes Official Rules March 2016
    get '/partners-in-crime-terms' => 'statics#prom_competition_terms', as: :partners_in_crime_terms

    ###########
    # Lookbooks
    ###########

    get '/lp/1512/1' => 'products/collections#show', :permalink => 'bring-on-the-night', :as => :advertising_landing_page_1, :pids => ["339-burgundy", "431-cherry-red", "713-red", "191-burgundy" ,"439-red", "371-cherry-red", "546-burgundy", "619-cherry-red", "539-red", "355-burgundy"]
    get '/lp/1512/1/p1' => redirect("/lp/1512/1?text=Did%20Justin%20Bieber%20get%20back%20with%20Selena%20because%20of%20THIS%20dress?")
    get '/lp/1512/1/p2' => redirect("/lp/1512/1?text=Selena%27s%20Sexy%20New%20Look%20that%20got%20Bieber%20Back")
    get '/lp/1512/1/p3' => redirect("/lp/1512/1?text=Selena%20shocks%20us%20with%20her%20Latest%20look")
    get '/lp/1512/1/p4' => redirect("/lp/1512/1?text=Selena%20Gomez's%20Sexy%20New%20Look,%20Internet%20goes%20mad")
    get '/lp/1512/2' => 'products/collections#show', :permalink => 'bring-on-the-night', :as => :advertising_landing_page_2, :pids => ["680-forest-green", "648-black", "682-gunmetal", "191-black", "539-magenta", "99-black", "431-black", "428-navy", "630-white", "471-burgundy"]
    get '/lp/1512/2/p1' => redirect("/lp/1512/2?text=The%20New,%20Celebrity-approved%20Way%20to%20show%20some%20Skin")
    get '/lp/1512/2/p2' => redirect("/lp/1512/2?text=The%20J-Law%20Endorsed,%20Must%20try%20Trend%20for%202016")
    get '/lp/1512/2/p3' => redirect("/lp/1512/2?text=Why%20are%20these%20Celebrities%20baring%20so%20much%20Skin?")
    get '/lp/1512/2/p4' => redirect("/lp/1512/2?text=These%20IT-Girls%20know%20the%20Perfect%20Party%20Dress")
    get '/lp/1512/3' => 'products/collections#show', :permalink => 'bring-on-the-night', :as => :advertising_landing_page_3, :pids => ["191-burgundy", "499-black", "582-white", "544-silver","514-black", "497-hot-pink", "612-gypsy-queen", "501-navy","620-white", "680-light-pink"]
    get '/lp/1512/3/p1' => redirect("/lp/1512/3?text=The%20Must-do%20Celebrity%20Trend%20for%20NYE")
    get '/lp/1512/3/p2' => redirect("/lp/1512/3?text=IT'S%20CONFIRMED:%20Angelina%20Jolie%20splits...%20with%20the%20dress")
    get '/lp/1512/3/p3' => redirect("/lp/1512/3?text=The%20craziest%20red%20carpet%20trend%20of%202015")
    get '/lp/1512/3/p4' => redirect("/lp/1512/3?text=Kendall%20Bares%20all!%20With%20the%20Skirt%20Split.")
    get '/lp/1512/4' => 'products/collections#show', :permalink => 'bring-on-the-night', :as => :advertising_landing_page_4, :pids => ["802-ice-grey", "809-blue-fallen-leaves", "800-pale-blue", "813-navy", "811-sage-fallen-leaves", "823-pale-pink", "793-ice-grey", "795-coral", "799-ice-blue", "804-mint"]
    get '/lp/1512/4/p1' => redirect("/lp/1512/4?text=8%20of%20the%20Most%20Awkward%20Bridesmaids%20photos%20of%20All%20Time")
    get '/lp/1512/4/p2' => redirect("/lp/1512/4?text=You%20won't%20Believe%20these%20Bridesmaids%20Photos!")
    get '/lp/1512/4/p3' => redirect("/lp/1512/4?text=What%20were%20they%20Thinking?!%20The%208%20Craziest%20Bridesmaids%20Photos.")
    get '/lp/1512/4/p4' => redirect("/lp/1512/4?text=Real-Life%20Bridesmaid%20that%20went%20that%20Step%20too%20Far")

    get '/lookbook' => 'statics#lookbook', :as => :lookbook
    get '/lookbook/jedi-cosplay' => redirect('/lookbook/make-a-statement')
    get '/lookbook/make-a-statement' => 'products/collections#show', :permalink => 'make-a-statement', :as => :make_a_statement_collection
    get '/lookbook/photo-finish' => 'products/collections#show', :permalink => 'photo-finish', :as => :photo_finish_collection
    get '/lookbook/the-luxe-collection' => 'products/collections#show', :permalink => 'luxe', :as => :luxe_collection

    get '/bring-on-the-night' => 'products/collections#show', :permalink => 'bring-on-the-night', :as => :bring_on_the_night_landing_page
    get '/lookbook/bring-on-the-night' => 'products/collections#show', :permalink => 'bring-on-the-night', :as => :bring_on_the_night_collection
    get '/lookbook/this-modern-romance' => 'products/collections#show', :permalink => 'this-modern-romance', :as => :this_modern_romance_collection

    get '/lookbook/garden-weeding' => redirect('/lookbook/garden-wedding')
    get '/lookbook/garden-wedding' => 'products/collections#show', :permalink => 'garden-party', :as => :garden_wedding_collection
    get '/here-comes-the-sun-collection' => redirect('/lookbook/here-comes-the-sun')

    get '/lookbook/here-comes-the-sun' => 'products/collections#show', :permalink => 'here-comes-the-sun', :as => :here_comes_the_sun_collection

    get '/lookbook/dance-hall-days' => 'products/collections#show', :permalink => 'dance-hall', :as => :dance_hall_days_collection
    get '/sarah-ellen' => 'products/collections#show', :permalink => 'dance-hall', :as => :sarah_ellen_landing_page
    get '/dresses/best-sellers' => 'products/collections#show', :as => :best_sellers
    get '/lookbook/formal-night' => 'products/collections#show', :permalink => 'formal-night', :as => :formal_night_landing_page
    get '/lookbook/race-day' => 'products/collections#show', :permalink => 'race-day', :as => :formal_night_landing_page

    get '/new-years-eve-dresses' => redirect('/lookbook/break-hearts')
    get '/break-hearts-collection' => redirect('/lookbook/break-hearts')
    get '/lookbook/break-hearts' => 'products/collections#show', :permalink => 'breakhearts', :as => :break_hearts_collection
    get '/lookbook/the-ruffled-up-collection' => 'products/collections#show', :permalink => 'ruffle', :as => :the_ruffled_up_collection

    get '/sale-dresses' => redirect('/dresses/sale')
    get '/dresses/sale' => 'products/collections#show', :permalink => 'sale', :as => :sales_collection

    get '/rss/collections' => 'rss#collections', format: :rss, as: :collections_rss

    get '/bridesmaid-dresses' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :bridesmaid_collection
    get '/bridal-dresses'     => 'products/collections#show', :permalink => 'bridesmaid14', :as => :bridal_collection
    get '/wedding-guest'      => 'products/collections#show', :permalink => 'bridesmaid14', :as => :wedding_guest_collection
    get '/ad-plus-size'       => 'products/collections#show', :permalink => 'bridesmaid14', :as => :ad_plus_size_collection
    get '/partners-in-crime'   => 'products/collections#show', :permalink => 'bridesmaid14', :as => :partners_in_crime_competition
    get '/prom-ad'            => 'products/collections#show', :permalink => 'bridesmaid14', :as => :prom_ad_collection

    get '/lets-party'     => 'products/collections#show', :permalink => 'dance-hall', :as => :lets_party_collection
    get '/lookbook/love-lace-collection' => 'products/collections#show', :permalink => 'love-lace', :as => :love_lace_collection
    get '/lookbook/just-the-girls'       => 'products/collections#show', :permalink => 'just-the-girls', :as => :just_the_girls_collection
    get '/lookbook/partners-in-crime'    => 'products/collections#show', :permalink => 'partners-in-crime', :as => :partners_in_crime_collection
    get '/lookbook/la-belle-epoque'      => 'products/collections#show', :permalink => 'la-belle-epoque', :as => :la_belle_epoque_collection

    get '/all-size' => redirect('/lookbook/all-size')
    get '/lookbook/all-size' => 'products/collections#show', :permalink => 'all-size', :as => :all_size_collection

    get '/prom-collection' => redirect('/lookbook/prom')
    get '/lookbook/prom' => 'products/collections#show', :permalink => 'PROM2015', :as => :prom_collection

    get '/lookbook/bohemian-summer' => 'products/collections#show', :permalink => 'bohemian-summer', :as => :bohemian_summer_collection

    get '/amfam' => redirect('/wicked-game-collection')
    get '/amfam-dresses' => redirect('/wicked-game-collection')
    get '/wicked-game-collection' => 'statics#wicked_game', :as => :wicked_game_collection

    # Landing pages
    get '/fameweddings/bridesmaid' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :bridesmaid_landing_page
    get '/fameweddings/bride' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :brides_landing_page
    get '/fameweddings/guest' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :guest_bride_page

    get '/macys' => 'products/collections#show', :as => :macys
    get '/shop-social' => 'products/collections#show', :as => :shop_social

    # A long tradition of hacking shit in.
    if Features.active?(:getitquick_unavailable)
      get '/getitquick' => 'hacky_messages#getitquick_unavailable', :as => :fast_making_dresses
    else
      get '/getitquick' => 'products/collections#show', defaults: { fast_making: true }, as: 'fast_making_dresses'
    end

    post '/shared/facebook' => 'competition/events#share'

    ###########
    # User Cart
    ###########
    scope '/user_cart', module: 'user_cart' do
      root to: 'details#show', as: :user_cart_details

      get '/details'      => 'details#show'
      get '/order_delivery_date' => 'details#order_delivery_date'
      post '/promotion'   => 'promotions#create'

      post 'products' => 'products#create'
      delete 'products/:line_item_id' => 'products#destroy'
      delete 'products/:line_item_id/customizations/:customization_id' => 'products#destroy_customization'
      delete 'products/:line_item_id/making_options/:making_option_id' => 'products#destroy_making_option'
    end

    ########################
    # Dresses (and products)
    ########################
    get '/skirts' => 'products/collections#show', :permalink => 'skirt', :as => :skirts_collection

    scope '/dresses' do
      root to: 'products/collections#show', as: :dresses
      get '/', to: 'products/collections#show', as: :collection

      # Colors should behave like query strings, and not paths
      get '/dress-:product_slug/:color' => redirect { |params, req| "/dresses/dress-#{params[:product_slug]}?#{req.params.except(:product_slug, :site_version).to_query}" }
      get '/dress-:product_slug' => 'products/details#show'

      get '/outerwear-:product_slug', to: 'products/details#show', as: :outerwear_details

      #roots categories
      get '/style', to: redirect('/dresses')
      get '/style/:taxon', to: redirect('/dresses/%{taxon}')
      get '/event', to: redirect('/dresses')
      get '/event/:taxon', to: redirect('/dresses/%{taxon}')
      get '/sale-(:sale)' => 'products/collections#show', as: 'dresses_on_sale'
      get '/*permalink' => 'products/collections#show', as: 'taxon'
    end

    # Custom Dresses
    get '/custom-dresses(/*whatever)', to: redirect('/dresses')

    get '/celebrities', to: redirect('/dresses')
    get '/celebrities/(:id)', to: redirect('/dresses')
    get '/featured-bloggers/:id', to: redirect('/dresses')

    resource :product_variants, only: [:show]

    get '/lp/collection(/:collection)', to: redirect('/dresses')

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

    get 'reviews' => 'users/reviews#index', as: 'reviews'
    # eo account settings

    resources :product_reservations, only: [:create]

    # Old Blog Redirection (30/06/2015)
    get '/blog(/*anything)', to: redirect('http://blog.fameandpartners.com')

    #######################
    # (Others) Static pages
    #######################
    get '/about'   => 'statics#about', :as => :about_us
    get '/why-us'  => 'statics#why_us', :as => :why_us
    get '/team', to: redirect("http://www.fameandpartners.com/about")
    get '/terms'   => 'statics#ecom_terms'
    get '/privacy' => 'statics#ecom_privacy'
    get '/legal'   => 'statics#legal'
    get '/faqs'   => 'statics#faqs'
    get '/our-customer-service-improvements', to: redirect('/from-our-ceo')
    get '/from-our-ceo' => 'statics#from_our_ceo', :as => :from_our_ceo
    get '/how-it-works', to: redirect("/why-us")
    get '/size-guide'  => 'statics#size_guide', :as => :size_guide
    get '/growth-plan'  => 'statics#growth_plan', :as => :growth_plan

    get '/fashionista2014', to: redirect("/")
    get '/fashionista2014/info'   => 'statics#fashionista', :as => :fashionista_info
    get '/fashionista2014-winners'   => 'statics#fashionista_winner', :as => :fashionista_winner
    get '/compterms' => 'statics#comp_terms', :as => :competition_terms
    get '/plus-size',  to: redirect('/dresses/plus-size')

    namespace 'campaigns' do
      resource :email_capture, only: [:create], controller: :email_capture do
        collection do
          get :mailchimp
        end
      end
    end

    get '/fame-chain' => 'fame_chains#new'
    resource 'fame-chain', as: 'fame_chain', only: [:new, :create] do
      get 'success'
    end

    get '/style-consultation', to: redirect("/styling-session")

    get '/styling-session'  => 'style_sessions#new', as: :styling_session
    resource 'style-session', as: 'style_session', only: [:create]

    get '/wedding-consultation' => 'wedding_consultations#new', as: :wedding_consultation
    resource 'wedding-consultation', as: 'wedding_consultation', only: [:create]

    get '/contact/new', to: redirect('/contact'), as: :old_contact_page
    resource 'contact', as: 'contact', only: [:new, :create], path_names: { new: '/' } do
      get 'success'
    end
    post '/about' => 'contacts#join_team', as: :join_team

    # return form
    get '/returnsform', to: redirect('http://www.fameandpartners.com/assets/returnform.pdf'), as: 'returns_form'
    get '/returns', to: redirect('/faqs#collapse-returns-policy'), as: 'returns_policy'

    # External URLs
    get '/trendsetters', to: redirect('http://woobox.com/pybvsm')

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

    ############################################
    # Storefront (Search, Checkout and Payments)
    ############################################
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
  end


  resource :wedding_moodboard, controller: 'moodboards/weddings', only: [:edit, :update] do
    collection do
      get 'guests'
    end
  end

  resources :moodboards, except: [:destroy] do
    resources :items, controller: 'moodboard_items', only: [:create, :show, :destroy] do
      member do
        get :like_or_unlike
      end
    end
    resources :collaborators, controller: 'moodboard_collaborators', only: [:create, :index]
  end

  get 'moodboard', to: 'moodboards#index'
  get 'wishlist',  to: 'moodboards#index'

  resources :wishlists_items, only: [:create], controller: 'users/wishlists_items' do
    get 'move_to_cart', on: :member
  end

  resources :moodboard_item_comments, exclude: [:index, :show]

  ##################
  # Robots and Feeds
  ##################
  get '/robots', to: 'robots#show', constraints: { format: /txt/ }

  ######
  # Prom
  ######

  get '/prom/thanksbabe' => redirect('http://prom.fameandpartners.com?snapchat=true')
  get '/prom', :to => redirect { |params, request|
    if request.params.any?
      "http://prom.fameandpartners.com?#{request.params.to_query}"
    else
      'http://prom.fameandpartners.com'
    end
  }

  ################
  # User Campaigns
  ################
  resources :user_campaigns, only: [:create] do
    collection do
      get  :check_state
    end
  end

  #################
  # Mysterious URLs
  #################

  get '/undefined',    to: 'errors/mysterious_route#undefined'
  get '/au/undefined', to: 'errors/mysterious_route#undefined'
  get '/1000668',      to: 'errors/mysterious_route#undefined'

  #########
  # Widgets
  #########

  namespace :widgets do
    get 'main_nav' => 'site_navigations#main_nav'
    get 'footer'   => 'site_navigations#footer'
  end

  scope '/body-shape-calculator' do
    get '/' => 'marketing/body_shape_calculator#show'
    post '/store-measures' => 'marketing/body_shape_calculator#store_measures'
  end

  ##############
  # Admin routes
  ##############

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
      resources :orders do
        member do
          get 'mark_order_as_shipped', :as => 'mark_order_as_shipped'
        end
      end

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
        resource :celebrity_inspiration, :only => [:edit, :update]

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

      resources :sales, :except => [:show]

      # stock invent settings
      get 'stock_invent'                => 'stock_invent#edit',          as: :stock_invent
      put 'stock_invent'                => 'stock_invent#update'
      get 'stock_invent/status'         => 'stock_invent#status',        as: :stock_invent_status
      get 'stock_invent/auth'           => 'stock_invent#google_auth',   as: :stock_invent_access_token_request
      get 'stock_invent/auth_callback'  => 'stock_invent#auth_callback', as: :stock_invent_google_auth_callback

      get 'export_product_taxons_csv'  => 'products#export_product_taxons', as: :export_product_taxons_csv, defaults: { format: :csv }

      resources :products do
        resources :customisation_values
        resources :inspirations do
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
    end
  end

  mount AdminUi::Engine, at: '/fame_admin'
  mount Revolution::Engine => '/'

  match '*path', to: 'errors/invalid_format#capture_php', constraints: lambda { |request| request.path[/\.php$/] }
end
