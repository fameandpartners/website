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

  #######################################################
  # Temporary redirection to fix wrong path sent to users
  #######################################################

  # TODO: (May 26 2016) Every redirection on this block should live in the HTTP server and not in the application!
  if Features.active?(:redirect_to_com_au_domain)
    get '/au/*whatevs' => redirect(path: '/%{whatevs}', host: 'www.fameandpartners.com.au')
    get '/au' => redirect(path: '/', host: 'www.fameandpartners.com.au')
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

    get '/fashionitgirl2015', to: redirect('/it-girl')
    get '/fashionitgirlau2015', to: redirect('/it-girl')
    get '/fashionitgirlau2015/terms-and-conditions', to: redirect('/it-girl')

    get '/fashionitgirl2015-terms-and-conditions', to: redirect('/it-girl')
    get '/nyfw-comp-terms-and-conditions', to: redirect('/it-girl')
    get '/fashionitgirl2015-competition', to: redirect('/it-girl')

    get '/feb_2015_lp' => 'statics#facebook_lp', :as => :feb_2015_lp
    get '/facebook-lp' => 'statics#facebook_lp', :as => :facebook_lp
    get '/fame2015', to: redirect('/')
    get '/slayitforward', to: redirect('https://www.instagram.com/explore/tags/slayitforward/'), :as => :slay_it_forward

    # Redirecting collections (08/06/2015)
    get '/collection(/*anything)', to: redirect { |params, _| params[:site_version] ? "/#{params[:site_version]}/dresses" : '/dresses' }

    # Monday March 23 2015 TTL: 6 months
    get '/unidays' => 'statics#unidays_lp', :as => :unidays_lp

    get '/mystyle' => 'products/collections#show', :as => :mystyle_landing_page

    # Partners In Crime Sweepstakes Official Rules March 2016
    get '/partners-in-crime-terms' => 'statics#prom_competition_terms', as: :partners_in_crime_terms

    # i=change landing page
    get '/iequalchange' => 'statics#iequalchange', :permalink => 'iequalchange', :as => :iequalchange_landing_page

    # The Evening Shop landing page
    get '/the-evening-shop' => 'statics#landing_page_evening_shop', :permalink => 'the-evening-shop', :as => :the_evening_shop_landing_page

    # Bridesmaids Thank you landing page
    get '/thanks-bridesmaid' => 'statics#landing_page_thanks_bridesmaid', :permalink => 'thanks-bridesmaid', :as => :thanks_bridesmaid_landing_page

    # Thank You landing page
    get '/thanks-for-shopping' => 'statics#landing_page_regular_thank_you', :permalink => 'thank-you-for-shopping', :as => :thank_you_for_shopping_landing_page

    # VIP landing page
    get '/the-fame-experience' => 'statics#landing_page_fame_experience', :permalink => 'the-fame-experience', :as => :the_fame_experience_landing_page

    # Thanks Bride landing page
    get '/thanks-bride' => 'statics#landing_page_thanks_bride', :permalink => 'thanks-bride', :as => :thanks_bride_landing_page

    # Micro Influencer landing page
    get '/fame-society-application' => 'statics#landing_page_fame_society', :permalink => 'fame-society-application', :as => :fame_society_application_landing_page

    # Fame Society Invitation
    get '/fame-society-invitation', to: redirect('/dresses'), as: :fame_society_invitation_landing_page

    # "Invite a friend" landing page
    get '/invite' => 'statics#landing_page_invite', :permalink => 'fame-invite', :as => :invite_a_friend_landing_page

    # Internship landing page
    get '/internship' => 'statics#landing_page_internship', :permalink => 'fame-internship', :as => :internship_landing_page

    # IT Girl Internship Competition landing page
    get '/it-girl' => 'products/collections#show', :permalink => 'fame-it-girl', :as => :it_girl_landing_page
    # Redirect /IT-GIRL to /it-girl as many users are typing the first URL and seeing a 404 error page
    get '/IT-GIRL', to: redirect('/it-girl'), :as => :it_girl_page

    # Bridesmaid teaser landing page
    get '/coming-soon-custom-bridesmaid-dresses' => 'products/collections#show', :permalink => 'bridesmaid-teaser-page', :as => :bridesmaid_teaser_landing_page

    # Prom Red And Black Category page
    get '/prom-red-and-black' => 'products/collections#show', :permalink => 'prom-red-and-black', :as => :prom_red_and_black_landing_page

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

    # Redirect Lookbook page to homepage (due to legal issues)
    get '/lookbook', to: redirect('/'), :as => :lookbook

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

    get '/sale-dresses' => redirect('/dresses/sale')
    get '/dresses/sale' => 'products/collections#show', :permalink => 'sale', :as => :sales_collection

    get '/rss/collections' => 'rss#collections', format: :rss, as: :collections_rss

    get '/bridal-dresses'     => 'products/collections#show', :permalink => 'bridesmaid14', :as => :bridal_collection
    get '/wedding-guest'      => 'products/collections#show', :permalink => 'bridesmaid14', :as => :wedding_guest_collection
    get '/ad-plus-size'       => 'products/collections#show', :permalink => 'bridesmaid14', :as => :ad_plus_size_collection
    get '/partners-in-crime'   => 'products/collections#show', :permalink => 'bridesmaid14', :as => :partners_in_crime_competition
    get '/prom-ad' => redirect('/dresses/prom'), as: :prom_ad_collection

    get '/lets-party'     => 'products/collections#show', :permalink => 'dance-hall', :as => :lets_party_collection
    get '/lookbook/love-lace-collection' => 'products/collections#show', :permalink => 'love-lace', :as => :love_lace_collection
    get '/lookbook/just-the-girls'       => 'products/collections#show', :permalink => 'just-the-girls', :as => :just_the_girls_collection
    get '/lookbook/partners-in-crime'    => 'products/collections#show', :permalink => 'partners-in-crime', :as => :partners_in_crime_collection
    get '/lookbook/la-belle-epoque' => redirect('/lookbook')

    get '/all-size' => redirect('/lookbook/all-size')
    get '/lookbook/all-size' => 'products/collections#show', :permalink => 'all-size', :as => :all_size_collection

    get '/prom-collection' => redirect('/lookbook/prom')
    get '/lookbook/prom' => 'products/collections#show', :permalink => 'PROM2015', :as => :prom_collection

    get '/lookbook/bohemian-summer' => 'products/collections#show', :permalink => 'bohemian-summer', :as => :bohemian_summer_collection

    get '/amfam' => redirect('/wicked-game-collection')
    get '/amfam-dresses' => redirect('/wicked-game-collection')
    get '/wicked-game-collection' => 'statics#wicked_game', :as => :wicked_game_collection

    get '/tops'    => 'products/collections#show', :permalink => 'tops', :as => :tops_collection
    get '/outerwear'    => 'products/collections#show', :permalink => 'outerwear', :as => :outerwear_collection
    get '/pants'    => 'products/collections#show', :permalink => 'pants', :as => :pants_collection
    get '/festival' => 'products/collections#show', :permalink => 'festival', :as => :festival_page

    # High Contrast Collection
    get '/high-contrast' => 'products/collections#show', :permalink => 'high-contrast', :as => :high_contrast_collection

    # Modern Bridesmaid Collection
    get '/modern-bridesmaid-dresses' => 'products/collections#show', :permalink => 'modern-bridesmaid-dresses', :as => :modern_bridesmaid_collection
    get '/bridesmaid-dresses', to: redirect('/modern-bridesmaid-dresses'), :as => :bridesmaid_collection

    # Best of Fame Collection
    get '/best-of-fame' => 'products/collections#show', :permalink => 'best-of-fame', :as => :best_of_fame_collection

    # Lookbook v2.0 landing pages
    get '/brittany-xavier-high-summer-collection' => 'products/collections#show', :permalink => 'brittany-xavier-high-summer-collection', :as => :high_summer_collection

    # Cocktail Collection - Landing page
    get '/cocktail-collection' => 'products/collections#show', :permalink => 'cocktail-collection', :as => :cocktail_collection_landing_page

    # Spring Racing Collection - Landing page
    get '/spring-racing-collection' => 'products/collections#show', :permalink => 'spring-racing-collection', :as => :spring_racing_collection_landing_page

    # The Evening Hours Collection - Redirection
    get '/the-evening-hours-collection' => redirect("/dresses/evening"), :as => :evening_hours_collection_landing_page

    # Relaxed Evening Collection page (Inside/Out)- Landing page
    get '/inside-out-collection' => 'products/collections#show', :permalink => 'inside-out-collection', :as => :inside_out_collection_landing_page

    # Pre-Prom/Pre-Season Evening Collection - Landing page
    get '/pre-season-evening-collection' => 'products/collections#show', :permalink => 'pre-season-evening-collection', :as => :pre_season_evening_collection_landing_page

    # Modern Evening Collection - Landing page
    get '/the-modern-evening-collection' => 'products/collections#show', :permalink => 'modern-evening-collection', :as => :modern_collection_landing_page

    # Redirect with querystring for GA tracking (Marketing campaign)
    get '/bespoke-bridal', to: redirect('/bespoke-bridal-collection?utm_source=theknot')

    # Bespoke Bridal Sweepstakes - Landing page
    get '/bespoke-bridal-sweepstakes'   => 'products/collections#show', :permalink => 'bespoke-bridal-sweepstakes', :as => :bespoke_bridal_sweepstakes_landing_page

    # Lookbook pages redirects (due to legal issues)
    get '/skirts-collection', to: redirect('/skirts'), as: :skirts_collection_landing_page
    get '/gown-collection', to: redirect('/the-evening-shop/gowns'), as: :gown_collection_landing_page
    get '/dress-for-parties', to: redirect('/dresses/cocktail'), as: :dress_for_parties_page
    get '/lookbook/the-freshly-picked-collection', to: redirect('/dresses/cotton-dresses'), as: :the_freshly_picked_collection
    get '/lookbook/the-ruffled-up-collection', to: redirect('/dresses/ruffle'), as: :the_ruffled_up_collection

    # Redirect Every BODY Dance LPs due to legal issues
    get '/every-body-dance', to: redirect('/dresses/prom'), :as => :every_body_dance_collection
    get '/everybody-dance', to: redirect('/dresses/prom')
    get '/shop-every-body-dance', to: redirect('/dresses/prom'), :as => :shop_every_body_dance_collection

    # temporary patch. this dress link is bad so redirect it
    # get '/dresses/dress-the-millie-dress-1666', to: redirect('/dresses/prom')

    # Landing pages
    get '/fameweddings/bridesmaid' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :bridesmaid_landing_page
    get '/fameweddings/bride' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :brides_landing_page
    get '/fameweddings/guest' => 'products/collections#show', :permalink => 'bridesmaid14', :as => :guest_bride_page

    get '/macys' => 'products/collections#show', :as => :macys
    get '/shop-social' => 'products/collections#show', :as => :shop_social

    get '/dress-for-wedding', to: redirect('/?utm_source=legacy-dress-for-wedding'), :as => :dress_for_wedding_page
    get '/inside-out'  => 'products/collections#show', :permalink => 'inside-out', :as => :inside_out_page
    get '/the-holiday-edit' => 'products/collections#show', :permalink => 'holiday', :as => :holiday_edit_page

    get '/the-evening-shop/gowns' => 'products/collections#show', :permalink => 'evening-shop-gown', :as => :evening_shop_gown_page
    get '/the-evening-shop/slips' => 'products/collections#show', :permalink => 'evening-shop-slips', :as => :evening_shop_slips_page
    get '/the-evening-shop/fitted' => 'products/collections#show', :permalink => 'evening-shop-fitted', :as => :evening_shop_fitted_page
    get '/the-evening-shop/lace' => 'products/collections#show', :permalink => 'evening-shop-lace', :as => :evening_shop_lace_page
    get '/the-evening-shop/wraps' => 'products/collections#show', :permalink => 'evening-shop-wraps', :as => :evening_shop_wraps_page
    get '/the-evening-shop/cold-shoulder' => 'products/collections#show', :permalink => 'evening-shop-cold-shoulder', :as => :evening_shop_cold_shoulder_page
    get '/the-evening-shop/plunging' => 'products/collections#show', :permalink => 'evening-shop-plunging', :as => :evening_shop_plunging_page
    get '/the-evening-shop/embellished' => 'products/collections#show', :permalink => 'evening-shop-embellished', :as => :evening_shop_embellished_page
    get '/the-evening-shop/under-200' => 'products/collections#show', :permalink => 'evening-shop-200', :as => :evening_shop_under_200_page, :redirect => { :au => :evening_shop_under_249_page }
    get '/the-evening-shop/under-249', to: redirect('/the-evening-shop/under-300'), as: :evening_shop_under_249_page
    get '/the-evening-shop/under-300' => 'products/collections#show', :permalink => 'evening-shop-300', :as => :evening_shop_under_300_page, :redirect => { :us => :evening_shop_under_200_page }

    # Daywear Category Page
    get '/daywear' => 'products/collections#show', :permalink => 'daywear', :as => :daywear_page

    # Evening Category Page
    get '/dresses/evening' => 'products/collections#show', :permalink => 'evening', :as => :evening_page

    # Casual Category Page
    get '/dresses/casual' => 'products/collections#show', :permalink => 'casual', :as => :casual_page

    # Summer Weddings Collection Page
    get '/dresses/summer-weddings' => 'products/collections#show', :permalink => 'summer-weddings', :as => :summer_weddings_collection_page

    # Redirect old Spring Weddings to Summer Weddings Collection Page
    get '/dresses/spring-weddings', to: redirect('/dresses/summer-weddings'), as: :spring_weddings_collection_page

    # Burgundy Collection Page
    get '/dresses/burgundy' => 'products/collections#show', :permalink => 'burgundy', :as => :burgundy_collection_page

    # White Trend Page
    get '/trends-white' => 'products/collections#show', :permalink => 'white-trend', :as => :white_trend_page

    # Gingham & Stripes Category page
    get '/trends-gingham-stripe' => 'products/collections#show', :permalink => 'gingham-stripe-trend', :as => :gingham_stripe_trend_page

    # [LEGACY] Wedding Atelier App - Landing page
    get '/wedding-atelier(/*anything)' => redirect('/coming-soon-custom-bridesmaid-dresses?utm_source=legacy-wedding-atelier'), as: :wedding_atelier_app_landing_page

    # Casual Summer Styles Collection Page
    get '/casual-summer-styles' => 'products/collections#show', :permalink => 'casual-summer-styles', :as => :casual_summer_styles_page

    # Florals Collection Page
    get '/dresses/floral' => 'products/collections#show', :permalink => 'floral', :as => :florals_page

    # Fall Weddings Collection Page
    get '/dresses/fall-weddings' => 'products/collections#show', :permalink => 'fall-weddings', :as => :fall_weddings_page

    # Weddings and Parties Collection Page
    get '/weddings-and-parties' => 'products/collections#show', :permalink => 'weddings-and-parties', :as => :weddings_parties_page
    get '/dresses/wedding-guests', to: redirect('/weddings-and-parties')

    # The Anti-Fast Fashion Shop (2.0 Collection) Landing page
    # get '/the-anti-fast-fashion-shop'   => 'products/collections#show', :permalink => 'the-anti-fast-fashion-shop', :as => :the_anti_fast_fashion_shop_landing_page

    #############################
    # PROM LPs - Interview pages
    #############################
    # Prom LP - Larsen Thompson Interview page
    get '/larsen-thompson-interview' => 'products/collections#show', as: :larsen_thompson_prom_interview_page

    # Prom LP - Delilah Belle Hamlin Interview page
    get '/delilah-belle-hamlin-interview' => 'products/collections#show', as: :delilah_belle_hamlin_prom_interview_page

    # Prom LP - Diana Veras Interview page
    get '/diana-veras-interview' => 'products/collections#show', as: :diana_veras_prom_interview_page

    # Prom LP - Ashley Moore Interview page
    get '/ashley-moore-interview' => 'products/collections#show', as: :ashley_moore_prom_interview_page

    # Prom LP - Yorelis Apolinario Interview page
    get '/yorelis-apolinario-interview' => 'products/collections#show', as: :yorelis_apolinario_prom_interview_page

    # Prom LP - Nia Parker Interview page
    get '/nia-parker-interview' => 'products/collections#show', as: :nia_parker_prom_interview_page

    # Prom LP - Say Lou Lou Interview page
    get '/say-lou-lou-interview' => 'products/collections#show', as: :say_lou_lou_prom_interview_page

    #############################
    # Weddings & Parties - Say Lou Lou Edit page
    #############################
    get '/weddings-parties-say-lou-lou' => 'products/collections#show', as: :say_lou_lou_prom_edit_page
    get '/evening-collection-say-lou-lou', to: redirect("/weddings-parties-say-lou-lou")

    # Category pages used in the new Navigation bar (2018-04-19)
    get '/navigation-under-200' => 'products/collections#show', permalink: 'navigation-under-200', as: :navigation_under_200_page
    get '/navigation-all-separates' => 'products/collections#show', permalink: 'navigation-all-separates', as: :navigation_all_separates_page
    get '/navigation-work' => 'products/collections#show', permalink: 'navigation-work', as: :navigation_work_page
    get '/navigation-night-out' => 'products/collections#show', permalink: 'navigation-night-out', as: :navigation_night_out_page
    get '/navigation-day' => 'products/collections#show', permalink: 'navigation-day', as: :navigation_day_page
    get '/navigation-bridal' => 'products/collections#show', permalink: 'navigation-bridal', as: :navigation_bridal_page
    get '/navigation-vacation' => 'products/collections#show', permalink: 'navigation-vacation', as: :navigation_vacation_page

    # A long tradition of hacking shit in.
    if Features.active?(:getitquick_unavailable)
      get '/getitquick' => 'statics#getitquick_unavailable', as: :fast_making_dresses
    else
      get '/getitquick' => 'products/collections#show', defaults: { fast_making: true }, as: :fast_making_dresses
    end

    post '/shared/facebook' => 'competition/events#share'

    ###########
    # Super Collections
    ###########

    scope '/custom_dresses', module: :super_collections do
      get '/bridesmaid' => 'dresses#show'
    end

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

      post 'products/:line_item_id/making_options/:product_making_option_id' => 'products#create_line_item_making_option'
      delete 'products/:line_item_id/making_options/:making_option_id' => 'products#destroy_making_option'

    end

    ########################
    # Sample Sale
    ########################
    get '/sample-sale', to: redirect('/?utm_source=sample-sale-redirect')
    get '/sample-sale/:id', to: redirect('/?utm_source=sample-sale-redirect')

    ########################
    # Dresses (and products)
    ########################
    get '/skirts' => 'products/collections#show', :permalink => 'skirt', :as => :skirts_collection

    get '/products/fabric-swatches' => 'products/fabric_swatches#index'

    scope '/dresses' do
      root to: 'products/collections#show', :permalink => 'dress', as: :dresses
      get '/', to: 'products/collections#show', as: :collection

      # Colors should behave like query strings, and not paths
      get '/dress-:product_slug/:color' => redirect { |params, req| "/dresses/dress-#{params[:product_slug]}?#{req.params.except(:product_slug, :site_version).to_query}" }
      get '/dress-:product_slug' => 'products/details#show'

      get '/outerwear-:product_slug', to: 'products/details#show', as: :outerwear_details

      # Legacy routes and its redirections
      get '/style', to: redirect('/dresses')
      get '/style/:taxon', to: redirect('/dresses/%{taxon}')
      get '/event', to: redirect('/dresses')
      get '/event/:taxon', to: redirect('/dresses/%{taxon}')

      get '/wedding', to: redirect('/dresses/bridal')
      get '/short', to: redirect('/dresses/mini')

      get '/blue', to: redirect('/dresses/blue-purple')
      get '/white', to: redirect('/dresses/white-ivory')

      # Current collections
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

    get '/shopping_sprees/:shopping_spree_id/join' => 'shopping_sprees#join'

    # account settings
    resource :profile, only: [:show, :update], controller: 'users/profiles' do
      put 'update_image', on: :member
    end

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
    get '/privacy' => 'statics#ecom_privacy', :as => :privacy
    get '/legal'   => 'statics#legal'
    get '/faqs'   => 'statics#faqs'
    get '/our-customer-service-improvements', to: redirect('/from-our-ceo')
    get '/from-our-ceo' => 'statics#from_our_ceo', :as => :from_our_ceo
    get '/how-it-works', to: redirect("/why-us")
    get '/size-guide'  => 'statics#size_guide', :as => :size_guide
    get '/growth-plan', to: redirect("/about")
    get '/inside-out-sweepstakes'   => 'statics#inside_out_sweepstakes', :permalink => 'inside_out_sweepstakes', :as => :inside_out_sweepstakes
    get '/pre-register-bridal', to: redirect('/bespoke-bridal-collection'), as: :pre_register_bridal
    get '/pre-register-bridesmaid', to: redirect('/wedding-atelier'), as: :pre_register_bridesmaid_sweepstakes

    get '/get-the-look', to: redirect('http://blog.fameandpartners.com/step-by-step-guide-bridal-style/'), :as => :get_the_look

    get '/wholesale'   => 'statics#landing_page_wholesale', :permalink => 'wholesale', :as => :wholesale_page

    get '/fashionista2014', to: redirect("/it-girl")
    get '/fashionista2014/info', to: redirect("/it-girl"), as: :fashionista_info
    get '/fashionista2014-winners', to: redirect("/it-girl"), as: :fashionista_winner
    get '/compterms' => 'statics#comp_terms', :as => :competition_terms
    get '/plus-size',  to: redirect('/dresses/plus-size')

    namespace 'campaigns' do
      resource :email_capture, only: [:create], controller: :email_capture do
        collection do
          post :subscribe
        end
      end
    end

    get '/fame-chain' => 'fame_chains#new', as: :fame_chain
    resource 'fame-chain', as: 'fame_chain', only: [:create]

    get '/style-consultation', to: redirect("/styling-session")

    get '/styling-session', to: redirect("/?utm_source=legacy-styling-session-page"), as: :styling_session

    get '/wedding-consultation', to: redirect("/?utm_source=legacy-wedding-consultation-page"), as: :wedding_consultation

    get '/myer-styling-session' => 'myer_styling_sessions#new', as: :myer_styling_session
    resource 'myer-styling-session', as: 'myer_styling_session', only: [:create]

    get '/micro-influencer' => 'micro_influencer#new', as: :micro_influencer
    resource 'micro-influencer', as: 'micro_influencer', only: [:create]

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
    get '/style_quiz' => redirect('/style-quiz'), as: :old_style_quiz_redirection
    resource :style_quiz, only: [:show, :update], controller: 'style_quiz', path: 'style-quiz'

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

    post '/checkout/update/:state', :to => 'spree/checkout#update', :as => :update_checkout

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

  post 'shipments_update', to: 'shippo/shipments#update'

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


  # ----------
  # Dress Filter LP
  # ----------

  scope '/bridesmaids' do
    get '/' => 'products/bridesmaids#index'
    get '/dresses' => 'products/bridesmaids#show'
  end

  scope '/bridesmaid-dresses' do
    # Colors should behave like query strings, and not paths
    get '/:id' => 'products/details#bridesmaid_show'
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

      scope '/user_cart' do
        post 'products' => 'products#create'
      end

      # user profile
      get 'profile' => 'profiles#show'

      #upload products.*\.ccf$
      constraints DomainConstraint.new(/.*\.fameandgroups.com\/$/) do
        put '/product_upload' => 'product_upload#upload'
      end
      # user session
      devise_scope :spree_user do
        post 'user/login' => 'user_sessions#create'
        delete 'user/logout' => 'user_sessions#destroy'
      end

      get '/bridesmaids/incompatabilities' => 'bridesmaid#incompatabilities'
      get '/bridesmaids/:id' => 'bridesmaid#show'
      get '/bridesmaids' => 'bridesmaid#index'

      #fabric swatches
      get 'fabric_swatches' => 'fabric_swatches#index'

      delete '/rails_cache' => 'systems#clear_cache'
    end
  end

  # Returns
  get '/view-orders'    => 'returns#main', as: 'user_orders'
  get '/guest-returns'  => 'returns#guest'
  get '/order-lookup/'  => 'returns#lookup'

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

        resources :making_options, controller: 'product_making_options', except: [:destroy] do
          member do
            put :toggle
          end
        end

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

  get '/contentful' => 'contentful#main', as: :the_anti_fast_fashion_shop_landing_page

  ContentfulRoute.all.each do |cr|
    match cr.route_name, :controller => cr.controller, :action => cr.action
  end

end

# NOTE: Alexey Bobyrev 14 Feb 2017
# Method append used here to handle all request directly right after defined ones (including engines)
FameAndPartners::Application.routes.append do
  # NOTE: Alexey Bobyrev 14 Jan 2017
  # Any other routes are handled here (as ActionDispatch prevents RoutingError from hitting ApplicationController#rescue_action)

  # Added in something to explicity exclude devise routes from going to contentful
  match '*path', to: 'contentful#main', constraints: lambda { |request| (request.path !~ /auth/) }

  # match '*path', to: 'application#non_matching_request', as: 'routing_error'
end
