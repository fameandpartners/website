class PagesController < Spree::StoreController
  before_filter :authenticate_spree_user!, :only => [:my_boutique]
  before_filter :check_style_profile_presence!, :only => [:my_boutique]

  layout 'spree/layouts/spree_application'
  respond_to :html

  def my_boutique
    @recommended_dresses = Spree::Product.recommended_for(current_spree_user)
    ids = @recommended_dresses.map(&:id)
    @other_dresses = Spree::Product.active
    @other_dresses = @other_dresses.where(['spree_products.id NOT IN (?)', ids]) if ids.present?
    @other_dresses = @other_dresses.uniq.sample(4)

    @colors = Products::ColorsSearcher.new(Spree::Product.active).retrieve_colors
  end

  def search
    query_string = params[:q]

    @products = Tire.search('spree_products', :load => true) do
      query do
        string Tire::Utils.escape(query_string), :default_operator => 'AND' , :use_dis_max => true
      end
      filter :bool, :must => {
        :term => {
          :deleted => false
        }
      }
    end.results.results

    @colors = Products::ColorsSearcher.new(Spree::Product.active).retrieve_colors
  end

  def fb_auth
    if params[:prom]
      session[:spree_user_return_to] = main_app.new_custom_dress_path
    elsif params[:quiz]
      session[:show_quiz] = true
    end

    if session[:sign_up_reason].blank?
      if params[:prom]
        session[:sign_up_reason] = 'custom_dress'
      elsif params[:quiz]
        session[:sign_up_reason] = 'style_quiz'
      end
    end

    redirect_to spree.spree_user_omniauth_authorize_url(:provider => :facebook)
  end

  private

  def check_style_profile_presence!
    unless current_spree_user.style_profile.present?
      raise CanCan::AccessDenied
    end
  end
end
