class PagesController < Spree::StoreController
  #before_filter :authenticate_spree_user!, :only => [:my_boutique]
  #before_filter :check_style_profile_presence!, :only => [:my_boutique]

  layout 'spree/layouts/spree_application'
  respond_to :html

#  def my_boutique
#    @sorted_dresses = Spree::Product.recommended_for(current_spree_user, :limit => 28)
#    @recommended_dresses = @sorted_dresses.first(12)
#    @dresses = @sorted_dresses.from(12)
#
#    @style_profile = UserStyleProfile.find_by_user_id(current_spree_user.id)
#  end

  def search
    @query_string = params[:q]

    if @query_string.present?
      query_string = @query_string
      @products = Tire.search('spree_products', :load => { :include => :master }) do
        query do
          string Tire::Utils.escape(query_string), :default_operator => 'AND' , :use_dis_max => true
        end
        filter :bool, :must => {
          :term => {
            :deleted => false
          }
        }
        filter :exists, :field => :available_on
        filter :bool, :should => {
          :range => {
            :available_on => { :lte => Time.now }
          }
        }
      end.results.results
    else
      @products = []
    end
  end

  def fb_auth
    if params[:prom]
      session[:spree_user_return_to] = main_app.step1_custom_dresses_path
    elsif params[:quiz]
      session[:show_quiz] = true
    elsif params[:competition]
      session[:spree_user_return_to] = main_app.enter_competition_path(competition_id: Competition.current)
      session[:invite] = params[:invite]
      session[:competition] = params[:competition]
    elsif params[:personalization]
      session[:spree_user_return_to] = main_app.personalization_products_path(cf: 'custom-dresses-signup')
    end

    if session[:sign_up_reason].blank?
      if params[:prom]
        session[:sign_up_reason] = 'custom_dress'
      elsif params[:quiz]
        session[:sign_up_reason] = 'style_quiz'
      elsif params[:competition]
        session[:sign_up_reason] = 'competition'
      elsif params[:personalization]
        session[:sign_up_reason] = 'customise_dress'
      end
    end

    redirect_to spree.spree_user_omniauth_authorize_url(:provider => :facebook)
  end
=begin
  private

  def check_style_profile_presence!
    unless current_spree_user.style_profile.present?
      raise CanCan::AccessDenied
    end
  end

  def colors
    @colors ||= Products::ColorsSearcher.new(Spree::Product.active).retrieve_colors
  end

  helper_method :colors
=end
end
