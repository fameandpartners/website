class StaticsController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  require 'enumerator'

  layout 'statics'

  # enable showing of display banner
  before_filter :display_marketing_banner


  def about
    @title = "About Us - " + default_seo_title
    @description = "We design beautiful dresses for prom and many other occasions. We are a passionate team of fashionista's based in Sydney and NYC. " + default_meta_description
    render :layout => 'redesign/application'
  end

  def faqs
    @title = "FAQs - " + default_seo_title
    @description = "FAQs. " + default_meta_description
    render :layout => 'redesign/application'
  end

  def ecom_terms
    @title = "Terms & Conditions - " + default_seo_title
    @description = "Terms & Conditions. " + default_meta_description
    render :layout => 'redesign/application'
  end

  def why_us
    @title = "Why Us - " + default_seo_title
    @description = "Why Us. " + default_meta_description
    render :layout => 'redesign/application'
  end

  def ecom_privacy
    @title = "Privacy - " + default_seo_title
    @description = "Privacy. " + default_meta_description
    render :layout => 'redesign/application'
  end

  def fashionista_winner
    @title = "Fashionista 2014 Winner"
    @description = "Fashionista 2014 Winner. " + default_meta_description
    render :layout => 'redesign/application'
  end

  def bridesmaid_lp
    @title = "Bridesmaid Dresses | Beautiful Bridesmaid Gowns Online - Fame & Partners."
    @description = "Discover beautiful bridesmaid dresses at Fame & Partners. " + default_meta_description
    render :template => 'landing_pages/bridesmaids', :layout => 'redesign/application'
  end

  def break_hearts_not_banks
    @title = "Break Hearts not Banks | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners. " + default_meta_description
    render :template => 'landing_pages/break-hearts-not-banks', :layout => 'redesign/application'
  end

  def wicked_game
    @title = "The Wicked Game | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses at Fame & Partners. " + default_meta_description
    render :template => 'landing_pages/wicked_game', :layout => 'redesign/application'
  end

  def prom
    @title = "Prom | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses at Fame & Partners. " + default_meta_description
    render :template => 'landing_pages/prom', :layout => 'redesign/application'
  end

  def prom_lp
    @title = "Prom | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses at Fame & Partners. " + default_meta_description
    render :template => 'statics/prom_lp', :layout => 'redesign/application'
  end

  def sale
    @title = "Sale Items | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners. " + default_meta_description
    render :template => 'landing_pages/sale', :layout => 'redesign/application'
  end

  def facebook_lp
    @title = "Facebook | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners. " + default_meta_description
    render :template => 'landing_pages/facebook_lp', :layout => 'redesign/application'
  end

  # Monday March 23 2015 TTL: 6 months
  def unidays_lp
    @title = "Unidays | Beautiful Dresses - Fame & Partners."
    @description = "Discover beautiful dresses that don't break the bank at Fame & Partners. " + default_meta_description
    render :template => 'statics/unidays_lp', :layout => 'redesign/application'
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
    @title = "Our Team - " + default_seo_title
    @description = "Our great team. " + default_meta_description
  end

  def legal
    @title = "Legal - " + default_seo_title
    @description = "Legal. " + default_meta_description
  end

  def how_it_works
    @title = "How it Works - " + default_seo_title
    @description = "How it works. " + default_meta_description
  end

  def renxfame
    @title = "Rachel et Nicole Design Collaboration - " + default_seo_title
    @description = "Rachel et Nicole Design Collaboration. We are so proud of this insanely adorable collaboration between Fame and Rachel et Nicole. " + default_meta_description
  end

  def lilyxfame
    @title = "Lily Patchett Design Collaboration - " + default_seo_title
    @description = "Lily Patchett Design Collaboration. " + default_meta_description
  end

  def maryxfame
    @title = "Mary Manaila Design Collaboration - " + default_seo_title
    @description = "Mary Manaila Design Collaboration. " + default_meta_description
  end

  def fashionista
    @title = "Fashionista Program - " + default_seo_title
    @description = "Fashionista Program. " + default_meta_description
  end

  def nyfw_comp_terms_and_conditions
    @title = "NYFW Competition 2015." + default_seo_title
    @description = "NYFW Competition 2015. " + default_meta_description
  end

  def girlfriendxfame

    if !spree_user_signed_in?
      session[:spree_user_return_to] = girlfriendxfame_path(site_version: current_site_version.code)
    else
      @competition_participation = CompetitionParticipation.find_or_create_by_spree_user_id(spree_current_user.id)
    end

    @title = "Girlfriend x Fame & Partners Collaboration - " + default_seo_title
    @description = "Girlfriend Magazine x Fame & Partners Collaboration. " + default_meta_description
  end

  def nye
    @title = "New Years Eve Dresses - " + default_seo_title
    @description = "Perfect NYE Dresses 2014. " + default_meta_description
  end

  def us_prom_2015_lp
    @nofollow = true
    @title = "Prom Dresses | Beautiful Prom Dresses Online - Fame & Partners."
    @description = "Discover beautiful prom dresses at Fame & Partners. " + default_meta_description
  end

  def amfam_lp
    @title = "AMFAM Dresses - " + default_seo_title
    @description = "AMFAM Collaboration. " + default_meta_description
  end

  def christmas_gift
    @title = "Christmas Gift Dresses - " + default_seo_title
    @description = "Perfect Christmas Dresses 2014. " + default_meta_description
  end

  def fashion_it_girl
    @title = "Fashion IT Girl. " + default_seo_title
    @description = "Fashion IT Girl 2015. " + default_meta_description
  end

  def fashion_it_girl_competition
    @title = "Fashion IT Girl. " + default_seo_title
    @description = "Fashion IT Girl 2015. " + default_meta_description
  end

  def fashion_it_girl_terms_and_conditions
    @title = "Fashion IT Girl. " + default_seo_title
    @description = "Fashion IT Girl 2015. " + default_meta_description
  end

  def fame2015
    @title = "Hashtag #fame2015 to win. " + default_seo_title
    @description = "Hashtag #fame2015 to win. " + default_meta_description
  end

  private

  def get_products_from_edit (edit, currency, user, count=9)
    searcher = Products::ProductsFilter.new(:edits => edit)
    searcher.current_user = user
    searcher.current_currency = currency
    searcher.products.first(count)
  end

  helper_method :get_products_from_edit

end
