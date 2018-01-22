class Products::FabricSwatchesController < Products::BaseController
  include Marketing::Gtm::Controller::Collection
  respond_to :html

  layout 'custom_experience/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def index
    @swatches = Rails.cache.fetch('fabric_swatches_heavy') do
      prd = Spree::Product.find_by_name('Fabric Swatch - Heavy Georgette')

      prd.variants.map do |swatch_variant|
        {
          variant_id: swatch_variant.id,
          product_id: swatch_variant.product.id,
          sku: swatch_variant.sku,
          color_name: swatch_variant.dress_color.presentation,
          color_id: swatch_variant.dress_color.id,
          color_hex: swatch_variant.dress_color.value,
          price: swatch_variant.prices.first.amount
        }
      end
    end
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
