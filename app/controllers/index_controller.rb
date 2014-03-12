class IndexController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  helper :all

  respond_to :html 

  def show
    if params[:workshop]
      session[:sign_up_reason] = 'workshop'
    end
    if params[:cf].to_s.match(/^competition-\w+/)
      @show_competition_quiz = true
    end
  end

  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
  end

  private

  def featured_products
    @featured_products ||= Spree::Product.active.featured.uniq.includes(:master)
  end

  helper_method :featured_products
end
