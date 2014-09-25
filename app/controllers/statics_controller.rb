class StaticsController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  require 'enumerator'
  
  layout 'statics'

  # enable showing of display banner
  before_filter :display_marketing_banner

  def fashionistacomp
    @title = "Fashionista 2014 Competition"
    @searcher = Products::ProductsFilter.new(:edits => "fashionista")
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
  end

  def fashionista_winner
    @title = "Fashionista 2014 Winner"
    @description = "Fashionista 2014 Winner. " + default_meta_description
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

  def about
    @title = "About Us - " + default_seo_title
    @description = "We design beautiful dresses for prom and many other occasions. We are a passionate team of fashionista's based in Sydney and NYC. " + default_meta_description
  end

  def team
    @title = "Our Team - " + default_seo_title
    @description = "Our great team. " + default_meta_description
  end

  def ecom_terms
    @title = "Terms & Conditions - " + default_seo_title
    @description = "Terms & Conditions. " + default_meta_description
  end

  def ecom_privacy
    @title = "Privacy - " + default_seo_title
    @description = "Privacy. " + default_meta_description
  end

  def legal
    @title = "Legal - " + default_seo_title
    @description = "Legal. " + default_meta_description
  end

  def faqs
    @title = "FAQs - " + default_seo_title
    @description = "FAQs. " + default_meta_description
  end

  def how_it_works
    @title = "How it Works - " + default_seo_title
    @description = "How it works. " + default_meta_description
  end
  
  def nyemix
    @title = "MUSIC MIX / I LIKE MY MUSIC LOUD - " + default_seo_title
    @description = "Music Mix - Do the songs match the dress? Get a discount off dresses. " + default_meta_description
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

  def girlfriendxfame
    if !spree_user_signed_in?
      session[:spree_user_return_to] = girlfriendxfame_path(site_version: current_site_version.code)
    else
      @competition_participation = CompetitionParticipation.find_or_create_by_spree_user_id(spree_current_user.id)
    end

    @title = "Girlfriend x Fame & Partners Collaboration - " + default_seo_title
    @description = "Girlfriend Magazine x Fame & Partners Collaboration. " + default_meta_description
  end

  private

  def get_products_from_edit (edit, currency, user, count=9)
    searcher = Products::ProductsFilter.new(:edits => edit)
    searcher.current_user = user
    searcher.current_currency = currency
    return searcher.products.first(count)
  end

  helper_method :get_products_from_edit
  
end
