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
      moodboard_owner_moodboard.items.map do |item|
        item.path = product_path(item)
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
end
