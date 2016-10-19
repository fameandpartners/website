class StaticsController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  require 'enumerator'

  layout 'redesign/application'

  # enable showing of display banner
  before_filter :display_marketing_banner


  def about
    @title = "About Us " + default_seo_title
    @description = "We design beautiful dresses for prom and many other occasions. We are a passionate team of fashionista's based in Sydney and NYC"
    @contact = Contact.new(site_version: current_site_version.code)
  end

  def faqs
    @title       = ['FAQs ', default_seo_title].join
    @description = 'FAQs'
  end

  def size_guide
    @title = "New Size Guide " + default_seo_title
    @description = "Size Guides"
  end

  def ecom_terms
    @title = "Terms & Conditions " + default_seo_title
    @description = "Terms & Conditions"
  end

  def from_our_ceo
    @title = "From our CEO " + default_seo_title
    @description = "From our CEO"
  end

  def why_us
    @title = "Why Us " + default_seo_title
    @description = "Why Us"
  end

  def ecom_privacy
    @title = "Privacy " + default_seo_title
    @description = "Privacy"
  end

  def fashionista_winner
    @title = "Fashionista 2014 Winner"
    @description = "Fashionista 2014 Winner"
  end

  def bridesmaid_lp
    @title = "Bridesmaid Dresses | Beautiful Bridesmaid Gowns Online - Fame & Partners"
    @description = "Discover beautiful bridesmaid dresses at Fame & Partners"
    render :template => 'landing_pages/bridesmaids', :layout => 'redesign/application'
  end

  def break_hearts_not_banks
    @title = "Break Hearts not Banks | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners"
    render :template => 'landing_pages/break-hearts-not-banks', :layout => 'redesign/application'
  end

  def lookbook
    @title = "Lookbooks | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners"
    render :template => 'landing_pages/lookbook', :layout => 'redesign/application'
  end

  def here_comes_the_sun
    @title = "Here comes the sun | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful summer dresses here at Fame & Partners"
    render :template => 'landing_pages/here_comes_the_sun', :layout => 'redesign/application'
  end


  def bohemian_summer
    @title = "Bohemian Summer | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful summer dresses here at Fame & Partners"
    render :template => 'landing_pages/bohemian_summer', :layout => 'redesign/application'
  end

  def all_size
    @title = "All Size | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses for every body here at Fame & Partners"
    render :template => 'landing_pages/all_size', :layout => 'redesign/application'
  end

  def wicked_game
    @title = "The Wicked Game | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses at Fame & Partners"
    render :template => 'landing_pages/wicked_game', :layout => 'redesign/application'
  end

  def prom
    @title = "Prom | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses at Fame & Partners"
    render :template => 'landing_pages/prom', :layout => 'redesign/application'
  end

  def prom_lp
    @title = "Prom | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses at Fame & Partners"
    render :template => 'statics/prom_lp', :layout => 'redesign/application'
  end

  def sale
    @title = "Sale Items | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners"
    render :template => 'landing_pages/sale', :layout => 'redesign/application'
  end

  def facebook_lp
    @title = "Facebook | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners"
    render :template => 'landing_pages/facebook_lp', :layout => 'redesign/application'
  end

  # Monday March 23 2015 TTL: 6 months
  def unidays_lp
    @title = "Unidays | Beautiful Dresses - Fame & Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners"
    render :template => 'statics/unidays_lp', :layout => 'redesign/application'
  end

  def getitquick_unavailable
    title('Get it Quick', default_seo_title)

    render 'getitquick_unavailable', status: :not_found
  end

# =======================================================================
# OLD PAGES
# =======================================================================

  def fashionistacomp
    @title = "Fashionista 2014 Competition"
    @searcher = Products::ProductsFilter.new(:edits => "fashionista")
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
  end

  def landingpage_plus_size
    @title = "Plus Size Dresses"

    user = try_spree_current_user
    currency = current_currency

    @plus_size_dresses = get_products_from_edit('plus-size', currency, user, 11)
    @plus_size_dresses_other = get_products_from_edit('plus-size-other', currency, user, 16)
  end

  def nylonxfame
    render layout: 'statics_fullscreen'
    @title = "About Fame & Partners"
  end

  def team
    @title = "Our Team " + default_seo_title
    @description = "Our great team"
  end

  def legal
    @title = "Legal " + default_seo_title
    @description = "Legal"
  end

  def how_it_works
    @title = "How it Works " + default_seo_title
    @description = "How it works"
  end

  def renxfame
    @title = "Rachel et Nicole Design Collaboration " + default_seo_title
    @description = "Rachel et Nicole Design Collaboration. We are so proud of this insanely adorable collaboration between Fame and Rachel et Nicole"
  end

  def lilyxfame
    @title = "Lily Patchett Design Collaboration " + default_seo_title
    @description = "Lily Patchett Design Collaboration"
  end

  def maryxfame
    @title = "Mary Manaila Design Collaboration " + default_seo_title
    @description = "Mary Manaila Design Collaboration"
  end

  def fashionista
    @title = "Fashionista Program " + default_seo_title
    @description = "Fashionista Program"
  end

  def nyfw_comp_terms_and_conditions
    @title = "NYFW Competition 201" + default_seo_title
    @description = "NYFW Competition 2015"
  end

  def girlfriendxfame

    if !spree_user_signed_in?
      session[:spree_user_return_to] = girlfriendxfame_path(site_version: current_site_version.code)
    else
      @competition_participation = CompetitionParticipation.find_or_create_by_spree_user_id(spree_current_user.id)
    end

    @title = "Girlfriend x Fame & Partners Collaboration " + default_seo_title
    @description = "Girlfriend Magazine x Fame & Partners Collaboration"
  end

  def nye
    @title = "New Years Eve Dresses " + default_seo_title
    @description = "Perfect NYE Dresses 2014"
  end

  def us_prom_2015_lp
    @nofollow = true
    @title = "Prom Dresses | Beautiful Prom Dresses Online - Fame & Partners"
    @description = "Discover beautiful prom dresses at Fame & Partners"
  end

  def amfam_lp
    @title = "AMFAM Dresses " + default_seo_title
    @description = "AMFAM Collaboration"
  end

  def fashion_it_girl
    @title = "Fashion IT Girl" + default_seo_title
    @description = "Fashion IT Girl 2015"
  end

  def fashion_it_girl_au_2015
    @title = "Fashion IT Girl Australia" + default_seo_title
    @description = "Fashion IT Girl Australia 2015"
  end

  def fashion_it_girl_au_tc
    @title = "Fashion IT Girl Australia" + default_seo_title
    @description = "Fashion IT Girl Australia 2015"
  end

  def fashion_it_girl_competition
    @title = "Fashion IT Girl" + default_seo_title
    @description = "Fashion IT Girl 2015"
  end

  def fashion_it_girl_terms_and_conditions
    @title = "Fashion IT Girl" + default_seo_title
    @description = "Fashion IT Girl 2015"
  end

  def fame2015
    @title = "Hashtag #fame2015 to win" + default_seo_title
    @description = "Hashtag #fame2015 to win"
  end

  # Legacy marketing campaign
  # def landing_page_mobile
  #   @title = 'A mid-summer night out'
  #   @disable_notices = true
  #   @page_variant = params[:variant].to_s || "1"
  #   case @page_variant
  #     when "1"
  #     @blogger_link = "Check out Tricia\'s Blog at <a href='http://triciacentenera.com/'>triciacentenera.com</a>"
  #     @holy_dress_link = "http://www.fameandpartners.com/dresses/dress-holly-493?color=black"
  #     @three_products_dress1_link = "http://www.fameandpartners.com/dresses/dress-melanie-two-piece-587?color=white"
  #     @three_products_dress2_link = "http://www.fameandpartners.com/dresses/dress-chevron-two-piece-566?color=burgundy"
  #     @three_products_dress3_link = "http://www.fameandpartners.com/dresses/dress-azalea-floral-two-piece-479?color=pink-azalea-floral"
  #
  #     @campaign_link1 = "http://www.fameandpartners.com/mystyle?lpi=insta1-dark-bg&lpt=Tricia's%20Recommended%20Dresses&pids%5B%5D=493-dusty-pink&pids%5B%5D=587-white&pids%5B%5D=566-burgundy&pids%5B%5D=493-ice-blue&pids%5B%5D=479-pink-azalea-floral&pids%5B%5D=493-black&pids%5B%5D=495-white&pids%5B%5D=575-surreal-floral-white&pids%5B%5D=582-merlot&pids%5B%5D=573-black&pids%5B%5D=599-monochrome&pids%5B%5D=508-white&pids%5B%5D=580-ice-blue&pids%5B%5D=602-watercolour&pids%5B%5D=493-ice-blue&pids%5B%5D=493-black"
  #     @campaign_link2 = "https://fameandpartners.com/mystyle?lpi=insta2a-dark-bg&lpt=Tricia's%20Recommended%20Dresses&pids[]=566-burgundy&pids[]=493-dusty-pink&pids[]=587-white&pids[]=566-blush&pids[]=479-pink-azalea-floral&pids[]=495-white&pids[]=575-surreal-floral-white&pids[]=582-merlot&pids[]=573-black&pids[]=599-monochrome&pids[]=508-white&pids[]=580-ice-blue&pids[]=602-watercolour&pids[]=566-blush"
  #     @bottom_collection_link = "http://www.fameandpartners.com/lookbook/bohemian-summer"
  #
  #     skus_colours = %w(
  #       495-white
  #       575-surreal-floral-white
  #       582-merlot
  #       573-black
  #       599-monochrome
  #       508-white
  #       580-ice-blue
  #       602-watercolour
  #     )
  #
  #   when "2"
  #     @blogger_link = "Check out Nada\'s Blog at <a href='http://www.nadaadelle.com/2015/07/lacey-dreams.html'>nadaadelle.com</a>"
  #     @holy_dress_link = "http://www.fameandpartners.com/dresses/dress-lace-petal-579?color=white"
  #     @three_products_dress1_link = "http://www.fameandpartners.com/dresses/dress-solace-517?color=white"
  #     @three_products_dress2_link = "http://www.fameandpartners.com/dresses/dress-shimmer-genie-569?color=pastel-peach"
  #     @three_products_dress3_link = "http://www.fameandpartners.com/dresses/dress-lace-debutante-474?color=white"
  #
  #     @campaign_link1 = "https://fameandpartners.com/mystyle?lpi=insta3&lpt=Nada's%20Recommended%20Dresses&pids[]=474-white&pids[]=569-pastel-peach&pids[]=579-white&pids[]=517-white&pids[]=587-white&pids[]=573-white&pids[]=468-black&pids[]=262-black"
  #     @campaign_link2 = "https://fameandpartners.com/mystyle?lpi=insta4&lpt=Nada's%20Recommended%20Dresses&pids[]=262-black&pids[]=474-white&pids[]=569-pastel-peach&pids[]=579-white&pids[]=517-white&pids[]=587-white&pids[]=573-white&pids[]=468-black"
  #     @bottom_collection_link = "http://www.fameandpartners.com/lookbook/the-luxe-collection"
  #     skus_colours = %w(
  #       474-white
  #       569-pastel-peach
  #       587-white
  #       573-white
  #       468-black
  #       262-white
  #       579-white
  #       517-white
  #     )
  #
  #   when "3"
  #     @blogger_link = "Check out Jenny\'s Blog at <a href='http://tsangtastic.com/2015/04/grasp-the-moment.html'>tsangtastic.com</a>"
  #     @holy_dress_link = "http://www.fameandpartners.com/dresses/dress-imogen-97?color=purple"
  #     @three_products_dress1_link = "http://www.fameandpartners.com/dresses/dress-high-places-592?color=red"
  #     @three_products_dress2_link = "http://www.fameandpartners.com/dresses/dress-sweet-dreamer-572?color=surreal-floral-white"
  #     @three_products_dress3_link = "http://www.fameandpartners.com/dresses/dress-tribe-of-love-595?color=tribal-love"
  #
  #     @campaign_link1 = "https://fameandpartners.com/mystyle?lpi=insta5&lpt=Jenny's%20Recommended%20Dresses&pids[]=595-tribal-love&pids[]=592-red&pids[]=97-purple&pids[]=572-surreal-floral-white&pids[]=593-surreal-floral-black&pids[]=599-monochrome&pids[]=573-white&pids[]=284-black&pids[]=602-watercolour&pids[]=623-light-pink&pids[]=505-black&pids[]=617-gypsy-scarf&pids[]=585-aqua&pids[]=355-navy&pids[]=97-burgundy"
  #     @campaign_link2 = "https://fameandpartners.com/mystyle?lpi=insta6&lpt=Jenny's%20Recommended%20Dresses&pids[]=593-surreal-floral-black&pids[]=599-monochrome&pids[]=97-burgundy&pids[]=595-tribal-love&pids[]=592-red&pids[]=572-surreal-floral-white&pids[]=573-white&pids[]=284-black&pids[]=602-watercolour&pids[]=623-light-pink&pids[]=505-black&pids[]=617-gypsy-scarf&pids[]=585-aqua&pids[]=355-navy"
  #     @bottom_collection_link = "http://www.fameandpartners.com/lookbook/the-luxe-collection"
  #     skus_colours = %w(
  #       573-white
  #       284-black
  #       602-watercolour
  #       623-light-pink
  #       505-black
  #       617-gypsy-scarf
  #       585-aqua
  #       355-navy
  #     )
  #   end
  #
  #   raw_products = Revolution::ProductService.new(skus_colours, current_site_version).products
  #
  #   product_collection = Products::CollectionPresenter.from_hash(products: raw_products)
  #
  #   product_collection.use_auto_discount!(current_promotion.discount) if current_promotion
  #
  #   @eight_products = product_collection.products
  #
  # end
end
