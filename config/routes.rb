FameAndPartners::Application.routes.draw do
  ############################
  # Devise Omniauth Workaround
  ############################
  # This is needed to make Facebook Login work.
  # Since we're redirecting every /us/* URL, facebook callback is being redirected twice
  devise_scope :spree_user do
    get '/us/user/auth/facebook/callback' => 'spree/omniauth_callbacks#facebook'
  end


  ###################################################################
  # Feed files redirections. They live above any `/us` + `/au` redirection
  ###################################################################
  get '/au/feeds/products/shopstyle.xml', to: 'marketing/feeds/shopstyle#au_feed'

  ########################
  # US Redirection to root
  ########################
  get '/us/*whatevs', to: redirect(path: "/%{whatevs}")
  get '/us' => redirect('/')
  get '/au/*whatevs' => redirect(path: '/%{whatevs}', host: 'www.fameandpartners.com.au')
  get '/au' => redirect(path: '/', host: 'www.fameandpartners.com.au')

  ##############################
  # Devise & User authentication
  ##############################
  if Features.active?(:new_account)
      devise_for :spree_user,
                  class_name:  'Spree::User',
                  controllers: { sessions:           'spree/user_sessions',
                                registrations:      'spree/user_registrations',
                                passwords:          'spree/user_passwords',
                                confirmations:      'spree/user_confirmations',
                                omniauth_callbacks: 'spree/omniauth_callbacks'
                  },
                  skip:        [:unlocks, :omniauth_callbacks],
                  path_names:  { sign_out: 'logout', sign_in: 'login', profile_path: 'profile_path' }

      devise_scope :spree_user do
        get '/spree_user/sign_in', to: redirect('/account/login'), :as => :login
        get '/signup', to: redirect('/account/signup'), :as => :sign_up
        get '/login', to: redirect('/account/login'), :as => :login
        get '/profile', to: redirect('/account/profile'), :as => :profile_path
      end
    else
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
  end


  devise_scope :spree_user do
    get '/user/auth/facebook/callback' => 'spree/omniauth_callbacks#facebook'
    get '/spree_user/thanks' => 'spree/user_registrations#thanks'
    get '/account_settings' => 'spree/user_registrations#edit'
  end

  # MonkeyPatch for store params & redirect to custom page
  get '/fb_auth' => 'spree/omniauth_facebook_authorizations#fb_auth'

  ##############
  # Fake routes
  ##############
  get '/dresses' => 'noop#noop', as: :dresses
  get '/dresses' => 'noop#noop', as: :collection
  get '/faqs' => 'noop#noop', as: :faqs
  get '/why-us' => 'noop#noop', as: :why_us
  get '/about' => 'noop#noop', as: :about_us
  get '/orders' => 'noop#noop', as: :user_orders
  get '/user' => 'noop#noop', as: :user
  get '/contact' => 'noop#noop', as: :contact
  get '/return/reason/:order_number/:email' => 'noop#noop', as: :new_user_returns
  get '/return/:order_number/(:request_id)' => 'noop#noop', as: :return_detail



  ########################
  # Redirect legacy pages
  ########################
  get '/wedding-atelier(/*anything)' => redirect('/custom-clothes/the-custom-clothing-studio?utm_source=legacy-wedding-atelier'), as: :wedding_atelier_app_landing_page
  get '/sale-dresses' => redirect('/dresses/sale')
  get '/slayitforward', to: redirect('https://www.instagram.com/explore/tags/slayitforward/'), :as => :slay_it_forward
  get '/coming-soon-custom-bridesmaid-dresses', to: redirect("/custom-clothes/the-custom-clothing-studio?utm_source=coming-soon-custom-bridesmaid-dresses"), :as => :bridesmaid_teaser_landing_page
  get '/the-evening-hours-collection' => redirect("/dresses/evening"), :as => :evening_hours_collection_landing_page
  get '/bespoke-bridal', to: redirect('/bespoke-bridal-collection?utm_source=theknot')
  get '/prom-ad' => redirect('/dresses/prom'), as: :prom_ad_collection
  get '/prom-collection' => redirect('/lookbook/prom')
  get '/bridesmaid-dresses', to: redirect('/modern-bridesmaid-dresses'), :as => :bridesmaid_collection
  get '/rss/collections' => 'rss#collections', format: :rss, as: :collections_rss
  get '/evening-collection-say-lou-lou', to: redirect("/weddings-parties-say-lou-lou")
  get '/dress-for-wedding', to: redirect('/?utm_source=legacy-dress-for-wedding'), :as => :dress_for_wedding_page
  get '/ad-plus-size', to: redirect("/?utm_source=legacy-ad-plus-size"), as: :ad_plus_size_collection
  get '/bridal-dresses', to: redirect("/?utm_source=legacy-bridal-dresses"), as: :bridal_collection
  get '/bring-on-the-night', to: redirect("/?utm_source=legacy-bring-on-the-night"), as: :bring_on_the_night_landing_page
  get '/compterms', to: redirect("/?utm_source=legacy-compterms"), as: :competition_terms
  get '/express-delivery', to: redirect("/?utm_source=legacy-express-delivery"), as: 'express_delivery'
  get '/fame-chain', to: redirect("/?utm_source=legacy-fame-chain"), as: :fame_chain
  get '/fameweddings/bridesmaid', to: redirect("/?utm_source=legacy-fameweddings-bridesmaid"), as: :bridesmaid_landing_page
  get '/fameweddings/bride', to: redirect("/?utm_source=legacy-fameweddings-bride"), as: :brides_landing_page
  get '/fameweddings/guest', to: redirect("/?utm_source=legacy-fameweddings-guest"), as: :guest_bride_page
  get '/fashionista2014', to: redirect("/it-girl")
  get '/fashionista2014/info', to: redirect("/it-girl"), as: :fashionista_info
  get '/fashionista2014-winners', to: redirect("/it-girl"), as: :fashionista_winner
  get '/fashionitgirl2015', to: redirect('/it-girl')
  get '/fashionitgirlau2015', to: redirect('/it-girl')
  get '/fashionitgirlau2015/terms-and-conditions', to: redirect('/it-girl')
  get '/fashionitgirl2015-terms-and-conditions', to: redirect('/it-girl')
  get '/fashionitgirl2015-competition', to: redirect('/it-girl')
  get '/nyfw-comp-terms-and-conditions', to: redirect('/it-girl')
  get '/legal', to: redirect("/terms?utm_source=legacy-legal")
  get '/lets-party', to: redirect("/?utm_source=legacy-lets-party"), as: :lets_party_collection
  get '/all-size', to: redirect('/lookbook/all-size')
  get '/new-years-eve-dresses', to: redirect('/lookbook/break-hearts')
  get '/break-hearts-collection', to: redirect('/lookbook/break-hearts')
  get '/here-comes-the-sun-collection', to: redirect('/lookbook/here-comes-the-sun')
  get '/lookbook', to: redirect('/?utm_source=legacy-lookbook'), as: :lookbook
  get '/lookbook/all-size', to: redirect("/?utm_source=legacy-lookbook-all-size"), as: :all_size_collection
  get '/lookbook/bohemian-summer', to: redirect('/?utm_source=legacy-lookbook-bohemian-summer'), as: :bohemian_summer_collection
  get '/lookbook/break-hearts', to: redirect('/?utm_source=legacy-lookbook-break-hearts'), as: :break_hearts_collection
  get '/lookbook/bring-on-the-night', to: redirect('/?utm_source=legacy-lookbook-bring-on-the-night'), as: :bring_on_the_night_collection
  get '/lookbook/dance-hall-days', to: redirect('/?utm_source=legacy-lookbook-dance-hall-days'), as: :dance_hall_days_collection
  get '/lookbook/formal-night', to: redirect('/?utm_source=legacy-lookbook-formal-night'), as: :formal_night_landing_page
  get '/lookbook/garden-wedding', to: redirect('/?utm_source=legacy-lookbook-garden-wedding'), as: :garden_wedding_collection
  get '/lookbook/here-comes-the-sun', to: redirect('/?utm_source=legacy-lookbook-here-comes-the-sun'), as: :here_comes_the_sun_collection
  get '/lookbook/jedi-cosplay', to: redirect('/lookbook/make-a-statement')
  get '/lookbook/just-the-girls', to: redirect('/?utm_source=legacy-lookbook-just-the-girls'), as: :just_the_girls_collection
  get '/lookbook/la-belle-epoque', to: redirect('/?utm_source=legacy-lookbook-la-belle-epoque')
  get '/lookbook/love-lace-collection', to: redirect('/?utm_source=legacy-lookbook-love-lace-collection'), as: :love_lace_collection
  get '/lookbook/make-a-statement', to: redirect('/?utm_source=legacy-lookbook-make-a-statement'), as: :make_a_statement_collection
  get '/lookbook/partners-in-crime', to: redirect('/?utm_source=legacy-lookbook-partners-in-crime'), as: :partners_in_crime_collection
  get '/lookbook/photo-finish', to: redirect('/?utm_source=legacy-lookbook-photo-finish'), as: :photo_finish_collection
  get '/lookbook/race-day', to: redirect('/?utm_source=legacy-lookbook-race-day'), as: :formal_night_landing_page
  get '/lookbook/the-luxe-collection', to: redirect('/?utm_source=legacy-lookbook-the-luxe-collection'), as: :luxe_collection
  get '/lookbook/this-modern-romance', to: redirect('/?utm_source=legacy-lookbook-this-modern-romance'), as: :this_modern_romance_collection
  get '/lookbook/the-freshly-picked-collection', to: redirect('/dresses/cotton-dresses'), as: :the_freshly_picked_collection
  get '/lookbook/the-ruffled-up-collection', to: redirect('/dresses/ruffle'), as: :the_ruffled_up_collection
  get '/sarah-ellen', to: redirect('/?utm_source=legacy-lookbook-sarah-ellen'), as: :sarah_ellen_landing_page
  get '/partners-in-crime-terms', to: redirect('/?utm_source=legacy-partners-in-crime-terms'), as: :partners_in_crime_terms
  get '/partners-in-crime', to: redirect('/?utm_source=legacy-partners-in-crime'), as: :partners_in_crime_competition
  get '/macys', to: redirect('/?utm_source=legacy-macys'), as: :macys
  get '/mystyle', to: redirect('/?utm_source=legacy-mystyle'), as: :mystyle_landing_page
  get '/skirts-collection', to: redirect('/skirts'), as: :skirts_collection_landing_page
  get '/gown-collection', to: redirect('/the-evening-shop/gowns'), as: :gown_collection_landing_page
  get '/dress-for-parties', to: redirect('/dresses/cocktail'), as: :dress_for_parties_page
  get '/every-body-dance', to: redirect('/dresses/prom'), :as => :every_body_dance_collection
  get '/everybody-dance', to: redirect('/dresses/prom')
  get '/shop-every-body-dance', to: redirect('/dresses/prom'), :as => :shop_every_body_dance_collection
  get '/the-holiday-edit', to: redirect('/?utm_source=legacy-the-holiday-edit'), as: :holiday_edit_page
  get '/unidays', to: redirect('/?utm_source=legacy-unidays'), as: :unidays_lp
  get '/amfam' => redirect('/wicked-game-collection')
  get '/amfam-dresses' => redirect('/wicked-game-collection')
  get '/wicked-game-collection', to: redirect('/?utm_source=legacy-the-wicked-game'), as: :wicked_game_collection
  get '/evening-collection-campaign', to: redirect('/dresses/evening?utm_source=legacy-evening-collection-campaign')
  get '/larsen-thompson-interview', to: redirect('/dresses/evening?utm_source=legacy-larsen-thompson-interview')
  get '/delilah-belle-hamlin-interview', to: redirect('/dresses/evening?utm_source=legacy-delilah-belle-hamlin-interview')
  get '/diana-veras-interview', to: redirect('/dresses/evening?utm_source=legacy-diana-veras-interview')
  get '/ashley-moore-interview', to: redirect('/dresses/evening?utm_source=legacy-ashley-moore-interview')
  get '/yorelis-apolinario-interview', to: redirect('/dresses/evening?utm_source=legacy-yorelis-apolinario-interview')
  get '/nia-parker-interview', to: redirect('/dresses/evening?utm_source=legacy-nia-parker-interview')
  get '/evening-collection-larsen-thompson', to: redirect('/dresses/evening?utm_source=legacy-evening-collection-larsen-thompson')
  get '/evening-collection-diana-veras', to: redirect('/dresses/evening?utm_source=legacy-evening-collection-diana-veras')
  get '/evening-collection-ashley-moore', to: redirect('/dresses/evening?utm_source=legacy-evening-collection-ashley-moore')
  get '/evening-collection-delilah-belle-hamlin', to: redirect('/dresses/evening?utm_source=legacy-delilah-belle-hamlin')
  get '/evening-collection-yorelis-apolinario', to: redirect('/dresses/evening?utm_source=legacy-yorelis-apolinario')
  get '/evening-collection-nia-parker', to: redirect('/dresses/evening?utm_source=legacy-nia-parker')
  get '/shop-evening-collection', to: redirect('/dresses/evening?utm_source=legacy-shop-evening-collection')
  get '/invite', to: redirect('/dresses/best-sellers?utm_source=legacy-invite'), :as => :invite_a_friend_landing_page
  get '/celebrities', to: redirect('/dresses')
  get '/celebrities/(:id)', to: redirect('/dresses')
  get '/featured-bloggers/:id', to: redirect('/dresses')
  get '/lp/collection(/:collection)', to: redirect('/dresses')
  get '/pre-register-bridal', to: redirect('/bespoke-bridal-collection'), as: :pre_register_bridal
  get '/pre-register-bridesmaid', to: redirect('/wedding-atelier'), as: :pre_register_bridesmaid_sweepstakes
  get '/get-the-look', to: redirect('http://blog.fameandpartners.com/step-by-step-guide-bridal-style/'), :as => :get_the_look
  get '/growth-plan', to: redirect("/about")
  get '/our-customer-service-improvements', to: redirect('/from-our-ceo')
  get '/how-it-works', to: redirect("/why-us")
  get '/team', to: redirect("http://www.fameandpartners.com/about")
  get '/plus-size',  to: redirect('/dresses/plus-size')
  get '/plus-size-styles',  to: redirect('/dresses/plus-size')
  get '/style-consultation', to: redirect("/styling-session")
  get '/styling-session', to: redirect("/?utm_source=legacy-styling-session-page"), as: :styling_session
  get '/wedding-consultation', to: redirect("/?utm_source=legacy-wedding-consultation-page"), as: :wedding_consultation
  get '/blog(/*anything)', to: redirect('http://blog.fameandpartners.com')
  get '/contact/new', to: redirect('/contact'), as: :old_contact_page


  get '/bridal-dresses', to: redirect('/dressses/bridal')
  get '/prom-red-and-black', to: redirect('/dresses/prom')
  get '/pre-season-evening-collection', to: redirect('/dresses/evening')
  get '/best-of-fame', to: redirect('/dresses/best-sellers')
  get '/the-modern-evening-collection', to: redirect('/dresses/evening')
  get '/the-evening-shop', to: redirect('/dresses/evening')
  get '/the-evening-shop(/*anything)', to: redirect('/dresses/evening')
  get '/the-anti-fast-fashion-shop', to: redirect('/dresses')
  get '/trends-white', to: redirect('/dresses/white-ivory')
  get '/shop-summer-collection', to: redirect('/dresses/spring')
  get '/casual-summer-styles', to: redirect('/dresses/spring')
  get '/shop-micro-floral', to: redirect('/dresses/floral')
  get '/navigation-bridal', to: redirect('/dresses/bridal')
  get '/bespoke-bridal-sweepstakes', to: redirect('/dresses/bridal')
  get '/modern-bridesmaid-dresses', to: redirect('/custom-clothes/pre-customized-styles')
  get '/navigation-under-200', to: redirect('/dresses/0-199')
  get '/cocktail-collection', to: redirect('/dresses/cocktail')
  get '/spring-racing-collection', to: redirect('/dresses/spring')
  get '/navigation-all-separates', to: redirect('/separates')
  get '/getitquick', to: redirect('/clothing/get-it-quick')
  get '/super-express-2018', to: redirect('/clothing/super-express')
  get '/shop-linen', to: redirect('/clothing/linen')
  get '/shop-polka-dot', to: redirect('/dresses/polka-dot')
  get '/navigation-work', to: redirect('/dresses/fw18')
  get '/navigation-night-out', to: redirect('/dresses/evening')
  get '/navigation-vacation', to: redirect('/dresses/vacation')
  get '/weddings-and-parties', to: redirect('/dresses/wedding-guests')
  get '/weddings-parties-say-lou-lou', to: redirect('/dresses/wedding-guests')
  get '/daywear', to: redirect('/dresses/daywear')
  get '/navigation-day', to: redirect('/dresses/daywear')
  get '/from-our-ceo', to: redirect('/about')
  get '/why-us', to: redirect('/about')
  get '/bespoke-bridal-collection', to: redirect('/dressses/bridal')
  get '/the-formal-collection', to: redirect('/dressses/prom')
  get '/snapchat-prom-offer', to: redirect('/dressses/prom')
  get '/holiday-party-survival-kit', to: redirect('/dressses/evening')
  get '/fresh-for-summer-collection', to: redirect('/collection/fresh-for-summer-collection')


  ###########
  # User Cart
  ###########
  scope '/user_cart', module: 'user_cart' do
    root to: 'details#show', as: :user_cart_details

    get '/details'      => 'details#show'
    post '/promotion'   => 'promotions#create'

    post 'products' => 'products#create'
    delete 'products/:line_item_id' => 'products#destroy'

    post 'products/:line_item_id/making_options/:product_making_option_id' => 'products#create_line_item_making_option'

    post '/restore' => 'products#restore'
  end

  ########################
  # Dresses (and products)
  ########################


  # account settings
  resource :profile, only: [:show, :update], controller: 'users/profiles' do
    put 'update_image', on: :member
  end

  # return form
  get '/returnsform', to: redirect('http://www.fameandpartners.com/assets/returnform.pdf'), as: 'returns_form'
  get '/returns', to: redirect('/faqs#collapse-returns-policy'), as: 'returns_policy'

  # External URLs
  get '/trendsetters', to: redirect('http://woobox.com/pybvsm')

  root :to => 'index#show'


  mount Spree::Core::Engine, at: '/'

  ############################################
  # Storefront (Search, Checkout and Payments)
  ############################################

  post '/checkout/update/:state', :to => 'spree/checkout#update', :as => :update_checkout

  # Guest checkout routes
  resources :payment_requests, only: [:new, :create]

  post 'shipments_update', to: 'shippo/shipments#update'

  ################
  # User Campaigns
  ################
  resources :user_campaigns, only: [:create] do
    collection do
      get  :check_state
    end
  end

  ##############
  # Admin routes
  ##############

  namespace :admin do
    resources :bulk_order_updates, :except => [:edit]
    resources :fabrications,       :only => :update
    resources :shipments,          :only => :update
  end

  # ----------
  # API Routes
  # ----------

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # returns
      get 'orders' => 'returns_processes#index'
      get 'guest/order' => 'returns_processes#guest'
      post 'submit_return' => 'returns_processes#create'

      # order history
      get 'order_history' => 'orders#history'

      scope '/user_cart' do
        post 'products' => 'products#create'
      end

      #upload products.*\.ccf$
      put '/product_upload' => 'product_upload#upload'

      get 'track' => 'tracking#track'
      post '/subscribe_newsletter' => 'tracking#subscribe_newsletter'

      # user session
      devise_scope :spree_user do
        post 'user/login' => 'user_sessions#create'
        post 'user/signup' => 'user_sessions#signup'
        post 'user/reset_password' => 'user_sessions#reset_password'
        post 'user/send_reset_password_email' => 'user_sessions#send_reset_password_email'
        post 'user/change_password' => 'user_sessions#change_password'
        post 'profile/update' => 'profiles#update'
        delete 'user/logout' => 'user_sessions#destroy'
      end

      get '/products/search' => 'products#search'
      get '/products/import_summary' => 'products#import_summary'
      get '/products/:id' => 'products#show'
      get '/products' => 'products#index'

      delete '/rails_cache' => 'systems#clear_cache'
    end
  end

  # Returns
  # get '/view-orders'    => 'returns#main', as: 'user_orders'
  # get '/guest-returns'  => 'returns#guest'
  get '/view-orders' => redirect('/orders')
  get '/guest-returns' => redirect('/return/guest')

  Spree::Core::Engine.routes.append do
    namespace :admin do
      resources :orders do
        member do
          get 'mark_order_as_shipped', :as => 'mark_order_as_shipped'
        end
      end

      post 'shipping_methods/update_positions' => "shipping_methods#update_positions"

      resources :site_versions, only: [:index, :edit, :update]

      scope 'products/:product_id', :as => 'product' do
        resources :fabrics, except: [:destroy], controller: 'product_fabrics'
      end

      resource :product_uploads, only: [:new, :create, :show] do
        post :parse, on: :member, as: 'parse'
        get :preview, on: :member, as: 'preview'
      end

      match '/product_images/upload' => 'product_images#upload', as: 'upload_product_images'

      resources :competition_entries, only: [:index, :show]

      resources :sales, :except => [:show]

      get 'export_product_taxons_csv'  => 'products#export_product_taxons', as: :export_product_taxons_csv, defaults: { format: :csv }

      resources :products do
        resources :customisation_values
        resources :layer_cads
        resources :curations

      
        resources :making_options, controller: 'product_making_options', except: [:destroy] do
          member do
            put :toggle
          end
        end
      end

      get 'modals' => 'modals#index'

      get 'search/order_owners' => 'search#order_owners'
    end
  end

  mount AdminUi::Engine, at: '/fame_admin'
end
