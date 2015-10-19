# this is not user wishlist, but bride wishlist
# we have to split it. later. it will be never, though
class Wishlist::UserWishlistResource
  include PathBuildersHelper

  attr_reader :site_version, :moodboard_owner

  def initialize(options = {})
    @site_version     = options[:site_version] || SiteVersion.default
    @moodboard_owner  = options[:owner]
  end

  def read
    OpenStruct.new({
      title:    'My Style Profile',
      owner:    moodboard_owner,
      is_owner: true,
      products: moodboard_products
    })
  end

  private

    def moodboard_owner_moodboard
      @moodboard_owner_moodboard ||= begin
        items = moodboard_owner.wishlist_items.includes(:variant, :color, product: [:master] ).map do |item|
          Repositories::UserMoodboardItem.new(item: item).read
        end

        ::UserMoodboard::DetailsPresenter.new(
          owner_name: moodboard_owner.full_name,
          owner_id: moodboard_owner.id,
          items: items
        )
      end
    end

    def moodboard_products
      moodboard_owner_moodboard.items.map do |item|
        item.path         = collection_product_path(item, site_version: site_version.to_param)
        item.discount     = Repositories::Discount.get_product_discount(item.product_id)
        item
      end
    end
end
