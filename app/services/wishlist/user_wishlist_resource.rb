class Wishlist::UserWishlistResource
  attr_reader :site_version, :moodboard_owner

  def initialize(options = {})
    @site_version     = options[:site_version]
    @moodboard_owner  = options[:owner]
  end

  def read
    OpenStruct.new({
      title:    'My Moodboard',
      owner:    moodboard_owner,
      is_owner: true,
      bride_moodboard: is_bride?,
      products: moodboard_products
    })
  end

  private

    def moodboard_owner_moodboard
      @moodboard_owner_moodboard ||= begin
        Repositories::UserWishlist.new(
          owner: moodboard_owner,
          site_version: site_version
        ).read
      end
    end

    def moodboard_products
      load_bridesmaides = bridesmaid_party_event.present?

      moodboard_owner_moodboard.items.map do |item|
        item.path = product_path(item)
        item.bridesmaides = get_bridesmaides_for_item(item.variant_id, item.color.try(:id))
        item
      end
    end

    def product_path(item)
      path_parts = [site_version.permalink, 'dresses']
      path_parts.push(
        ['dress', item.name.parameterize, item.product_id].reject(&:blank?).join('-')
      )
      if item.color.present?
        path_parts.push(item.color.name)
      end

      "/" + path_parts.compact.join('/')
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
      @bridesmaids ||= bridesmaid_party_event.members.includes(:spree_user)
    end

    def get_bridesmaides_for_item(variant_id, color_id)
      return [] unless is_bride?
      bridesmaids_selected = bridesmaids.select do |bridesmaid| 
        bridesmaid.color_id == color_id || bridesmaid.variant_id == variant_id
      end

      bridesmaids_selected.collect do |bridesmaid|
        OpenStruct.new({
          id: bridesmaid.id,
          name: bridesmaid.spree_user.try(:full_name) || bridesmaid.full_name,
          size: Spree::Variant.size_option_type.option_values.where(id: bridesmaid.size).first.try(:name),
          color: Spree::Variant.color_option_type.option_values.where(id: bridesmaid.color_id).first.try(:name)
        })
      end
    end
end
