class Products::BridesmaidsController < Products::BaseController
  include Marketing::Gtm::Controller::Collection
  include ProductsHelper
  respond_to :html

  layout 'custom_experience/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  # DRESS FILTER PAGE
  def index # only used to render slim
    @swatch_colors = fabric_swatch_colors.to_json
  end

  def show # only used to render slim
  end

  private

  def redirect_site_version
    redirect_path = params.dig(:redirect, current_site_version.permalink.to_sym)
    if redirect_path.present?
      redirect_to url_for(redirect_path)
    end
  rescue NoMethodError => e
    # :noop:
  end

  def redirect_undefined
    if params[:permalink] =~ /undefined\Z/
      redirect_to '/undefined', status: :moved_permanently
    end
  end
end
