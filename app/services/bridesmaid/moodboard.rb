class Bridesmaid::Moodboard
  attr_reader :site_version, :accessor, :moodboard_owner

  def initialize(options = {})
    @site_version     = options[:site_version]
    @accessor         = options[:accessor]
    @moodboard_owner  = options[:moodboard_owner]
  end

  def read
    OpenStruct.new({
      title:    title,
      owner:    moodboard_owner,
      is_owner: is_owner,
      products: moodboard_products
    })
  end

  private

    def title
      @title ||= "#{ moodboard_owner.full_name }'s mooodboard"
    end

    def is_owner
      accessor.present? && accessor == moodboard_owner
    end

    def moodboard_owner_moodboard
      @moodboard_owner_moodboard ||= begin
        Repositories::UserWishlist.new(
          owner: moodboard_owner,
          site_version: site_version
        ).read
      end
    end

    def currency
      site_version.currency.downcase
    end

    def bridesmaid_party_event
      @bridesmaid_party_event ||= BridesmaidParty::Event.where(spree_user_id: moodboard_owner.id).first_or_initialize
    end

    def moodboard_products
      moodboard_owner_moodboard.items.map do |item|
        item_suitable?(item) ? build_item(item) : nil
      end.compact
    end

    def product_discount(product_id)
      Repositories::Discount.get_product_discount(product_id)
    end

    def color_ids
      @color_ids ||= bridesmaid_party_event.color_ids
    end

    # we don't show red ( or similar ) dresses in moodboard, if user don't selected red color or unselected it
    # dresses, able to be customised also includes to list 
    def item_suitable?(item)
      item.color_customizable || begin
        if item.color.present?
          color_ids.include?(item.color.id)
        else
          (color_ids & item.product_color_ids).present?
        end
      end
    end

    def build_item(item)
      item.path = product_path(item)
      item.discount = product_discount(item.product_id)
      item
    end

    #'/moodboard/:user_slug/dress-:product_slug(/:color_name)'
    def product_path(item)
      path_parts = [site_version.permalink, 'bridesmaid-party', bridesmaid_party_event.spree_user.slug]
      path_parts.push(
        ['dress', item.name.parameterize, item.product_id].reject(&:blank?).join('-')
      )
      path_parts.push(item.color.name) if item.color.present?
      "/" + path_parts.compact.join('/')
    end
end
