class Bridesmaid::SelectedProduct
  attr_reader :accessor, :site_version, :moodboard_owner, :product, :variant_id, :color, :size, :customizations

  def initialize(options = {})
    @accessor         = options[:accessor]
    @site_version     = options[:site_version]
    @moodboard_owner  = options[:moodboard_owner]
    @product          = options[:product]
    @variant_id       = options[:variant_id]
    @color            = options[:color]
    @size             = options[:size]
    @customizations   = Array.wrap(options[:customizations])
  end

  def update
    validate!
    update_member_selection
    update_bride_moodboard
    notify_bride
  #rescue
  #  false
  end

  private

    # size, color, product should be
    def validate!
      if color.blank? || size.blank? || product.blank? || variant_id.blank?
        raise 'Invalid Settings' 
      end
    end

    def update_member_selection
      if member.present?
        member.variant_id = product_variant.id
        member.size = size.try(:id)
        member.color_id = color.try(:id)
        member.customization_value_ids = customizations
        member.save!
      end
    end

    def notify_bride
      if member.present?
        BridesmaidPartyMailer.delay.bridesmaid_send(moodboard_owner, member, site_version)
      end
    end

    def product_from_moodboard?
      if color.present?
        if moodboard_owner.wishlist_items.where(spree_product_id: product.id, product_color_id: color.try(:id)).exists?
          return true
        end
      end
      if moodboard_owner.wishlist_items.where(spree_variant_id: product_variant.id).exists?
        return true
      end

      false
    end

    def update_bride_moodboard
      if !product_from_moodboard?
        item = moodboard_owner.wishlist_items.build
        item.spree_product_id = product.id
        item.spree_variant_id = product_variant.try(:id)
        item.product_color_id = color.try(:id)
        item.save

        Repositories::UserWishlist.new(owner: moodboard_owner).drop_cache
      end
    end

    def product_variant
      # product
      # color
      # size
      # variant
      @product_variant ||= ( Spree::Variant.where(id: variant_id).first || product.master )
    end

    def bridesmaid_user_profile
      @bridesmaid_user_profile ||= moodboard_owner.bridesmaid_party_events.first
    end

    def member
      @member ||= begin
        bridesmaid_user_profile.members.where(spree_user_id: accessor.id).first ||
          bridesmaid_user_profile.members.where(email: accessor.email).first
      end
    end
end
