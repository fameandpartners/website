module UserCart; end
class UserCart::PromotionsService
  attr_reader :site_version, :order, :code

  def initialize(options = {})
    @site_version = options[:site_version] || SiteVersion.default
    @order        = options[:order]
    @code         = options[:code]
  end

  def apply
  end

  private

    def promotion
    end
end

