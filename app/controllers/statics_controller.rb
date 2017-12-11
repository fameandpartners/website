class StaticsController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  require 'enumerator'

  # layout 'returns/application'
  layout 'redesign/application'

  # enable showing of display banner
  before_filter :display_marketing_banner,
                :assign_revolution_page

  def about
    title('About Us', default_seo_title)
    description('We design beautiful dresses for prom and many other occasions. We are a passionate team of fashionista\'s based in Sydney and NYC')
    @contact = Contact.new(site_version: current_site_version.code)
  end

  def faqs
    @optimizely_opt_in = true
    @vwo_in = true
  end

  def bridesmaid_lp
    @title = "Bridesmaid Dresses | Beautiful Bridesmaid Gowns Online - Fame and Partners"
    @description = "Discover beautiful bridesmaid dresses at Fame and Partners"
    render :template => 'landing_pages/bridesmaids', :layout => 'redesign/application'
  end

  def break_hearts_not_banks
    @title = "Break Hearts not Banks | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame and Partners"
    render :template => 'landing_pages/break-hearts-not-banks', :layout => 'redesign/application'
  end

  def lookbook
    @title = "Lookbooks | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame and Partners"
    render :template => 'landing_pages/lookbook', :layout => 'redesign/application'
  end

  def here_comes_the_sun
    @title = "Here comes the sun | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful summer dresses here at Fame and Partners"
    render :template => 'landing_pages/here_comes_the_sun', :layout => 'redesign/application'
  end

  def bohemian_summer
    @title = "Bohemian Summer | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful summer dresses here at Fame and Partners"
    render :template => 'landing_pages/bohemian_summer', :layout => 'redesign/application'
  end

  def all_size
    @title = "All Size | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses for every body here at Fame and Partners"
    render :template => 'landing_pages/all_size', :layout => 'redesign/application'
  end

  def wicked_game
    @title = "The Wicked Game | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses at Fame and Partners"
    render :template => 'landing_pages/wicked_game', :layout => 'redesign/application'
  end

  def prom
    @title = "Prom | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses at Fame and Partners"
    render :template => 'landing_pages/prom', :layout => 'redesign/application'
  end

  def prom_lp
    @title = "Prom | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses at Fame and Partners"
    render :template => 'statics/prom_lp', :layout => 'redesign/application'
  end

  def sale
    @title = "Sale Items | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame and Partners"
    render :template => 'landing_pages/sale', :layout => 'redesign/application'
  end

  def facebook_lp
    @title = "Facebook | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame and Partners"
    render :template => 'landing_pages/facebook_lp', :layout => 'redesign/application'
  end

  def iequalchange
    if Features.inactive?(:i_equal_change)
      redirect_to about_us_path, status: 302
    end
  end

  # Monday March 23 2015 TTL: 6 months
  def unidays_lp
    @title = "Unidays | Beautiful Dresses - Fame and Partners"
    @description = "Discover beautiful dresses that don't break the bank at Fame and Partners"
    render :template => 'statics/unidays_lp', :layout => 'redesign/application'
  end

  def getitquick_unavailable
    title('Get it Quick', default_seo_title)

    render 'getitquick_unavailable', status: :not_found
  end

  def wedding_atelier_app
    if spree_current_user
      redirect_to wedding_atelier.events_path
    end
  end

# =======================================================================
# OLD PAGES
# =======================================================================

  def landingpage_plus_size
    @title = "Plus Size Dresses"

    user = try_spree_current_user
    currency = current_currency

    @plus_size_dresses = get_products_from_edit('plus-size', currency, user, 11)
    @plus_size_dresses_other = get_products_from_edit('plus-size-other', currency, user, 16)
  end

  def nylonxfame
    render layout: 'statics_fullscreen'
    @title = "About Fame and Partners"
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

  def girlfriendxfame

    if !spree_user_signed_in?
      session[:spree_user_return_to] = girlfriendxfame_path(site_version: current_site_version.code)
    else
      @competition_participation = CompetitionParticipation.find_or_create_by_spree_user_id(spree_current_user.id)
    end

    @title = "Girlfriend x Fame and Partners Collaboration " + default_seo_title
    @description = "Girlfriend Magazine x Fame and Partners Collaboration"
  end

  def nye
    @title = "New Years Eve Dresses " + default_seo_title
    @description = "Perfect NYE Dresses 2014"
  end

  def us_prom_2015_lp
    @nofollow = true
    @title = "Prom Dresses | Beautiful Prom Dresses Online - Fame and Partners"
    @description = "Discover beautiful prom dresses at Fame and Partners"
  end

  def amfam_lp
    @title = "AMFAM Dresses " + default_seo_title
    @description = "AMFAM Collaboration"
  end

  def fame2015
    @title = "Hashtag #fame2015 to win" + default_seo_title
    @description = "Hashtag #fame2015 to win"
  end

  private

  def assign_revolution_page
    if (page = Revolution::Page.find_for(request.path))
      @page        = page
      @page.locale = current_site_version.locale

      title(@page.title, default_seo_title)
      description(@page.meta_description)
    end
  end
end
