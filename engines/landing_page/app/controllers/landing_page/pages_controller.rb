module LandingPage
  class PagesController < ApplicationController

    def index  
      render :layout => 'landing_page/application'
    end

    def product_page      
      # Page.delete_all
      # Page.create!(:path => params[:path], :title => 'BlahVtha')
      page ||= Page.where(:path => params[:path]).first
      products =  [] #Products::ColorVariantsFilterer.new(params)
      @product_page_view ||= ProductPageView.new(page, products)
    end

    helper_method :product_page
  end
end

def not_index
    @searcher = Products::ColorVariantsFilterer.new(params)

    if params[:colour].blank? && params[:style].blank?
      @sorter = Products::ColorVariantsSorter.new(@searcher.color_variants)
      @sorter.sort!
      @color_variants = @sorter.results
    else
      @color_variants = @searcher.color_variants
    end

    similar_color_variants = @searcher.similar_color_variants
    if similar_color_variants.present?
      sorter = Products::ColorVariantsSorter.new(similar_color_variants)
      sorter.sort!
      @similar_color_variants = sorter.results
    end

    @current_colors = @searcher.colour.present? ? @searcher.colors_with_similar : []

    currency = current_currency
    user = try_spree_current_user

    display_featured_dresses = params[:dfd]
    display_featured_dresses_edit = params[:dfde]

    @page_info = @searcher.selected_products_info
    @category_title = @page_info[:page_title]
    @category_description = @page_info[:meta_description]
    @footer_text = @page_info[:footer_text]

    if (!display_featured_dresses.blank? && display_featured_dresses == "1") && !display_featured_dresses_edit.blank?
      @lp_featured_products = get_products_from_edit(display_featured_dresses_edit, currency, user, 4)
    end

    respond_to do |format|
      format.html do
        set_collection_title(@page_info)
        set_marketing_pixels(@searcher)

        render action: 'sorting', layout: true
      end
      format.json do
        self.formats += [:html]
        products_html = render_to_string(partial: 'spree/products/color_variants')
        render json: { products_html: products_html, page_info:  @page_info }
      end
      format.xml  { render 'feeds/simple_products', products: @color_variants}
    end
  end