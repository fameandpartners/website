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
      bride_moodboard: is_bride?,
      products: moodboard_products
    })
  end

  private

    def moodboard_owner_moodboard
      @moodboard_owner_moodboard ||= begin
        items = moodboard_owner.wishlist_items.includes(:variant, :color, product: {master: :zone_prices}).map do |item|
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
        item.bridesmaides = get_bridesmaides_for_item(item.product_id, item.variant_id, item.color.try(:id))
        item.discount     = Repositories::Discount.get_product_discount(item.product_id)
        item
      end
    end

    # module-specific code.
    # possible, should be extracted to child/other resource
    def is_bride?
      return @is_bride if instance_variable_defined?("@is_bride")
      @is_bride = bridesmaid_party_event.present?
    end

    def bridesmaid_party_event
      @bridesmaid_party_event ||= BridesmaidParty::Event.where(spree_user_id: moodboard_owner.id).first
    end

    def bridesmaids
      @bridesmaids ||= bridesmaid_party_event.members.includes(:spree_user, :variant)
    end

    def get_bridesmaides_for_item(product_id, variant_id, color_id)
      return [] unless is_bride?

      bridesmaids_selected = bridesmaids.select do |bridesmaid| 
        selected_product = bridesmaid.variant.try(:product_id)
        if bridesmaid.variant_id == variant_id
          true
        elsif selected_product.present? && selected_product == product_id
          true
        else
          false
        end
      end

      bridesmaids_selected.collect do |bridesmaid|
        OpenStruct.new({
          id: bridesmaid.id,
          name: bridesmaid.spree_user.try(:first_name) || bridesmaid.full_name,
          full_name: bridesmaid.spree_user.try(:full_name) || bridesmaid.full_name,
          size: Spree::Variant.size_option_type.option_values.where(id: bridesmaid.size).first.try(:name),
          color: Spree::Variant.color_option_type.option_values.where(id: bridesmaid.color_id).first.try(:name)
        })
      end
    end
end
