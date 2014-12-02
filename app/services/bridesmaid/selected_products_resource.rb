class Bridesmaid::SelectedProduct
  attr_reader :accessor, :moodboard_owner, :product, :variant_id, :color, :size

  def initialize(options = {})
    @accessor         = options[:accessor]
    @moodboard_owner  = options[:moodboard_owner]
    @product          = options[:product]
    @variant_id       = options[:variant_id]
    @color            = options[:color]
    @size             = options[:size]
  end

  def update
    update_member_selection
    update_bride_moodboard
    notify_bride
  #rescue
  #  false
  end

  private

    def update_member_selection
      if member.present?
        member.variant_id = product_variant.id
        member.size = size.try(:id)
        member.color_id = color.try(:id)
        member.save!
      end
    end

    def notify_bride
      if member.present?
        #
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
        bridesmaid_user_profile.members.where(
          email: accessor.email
        ).first
      end
    end
end

=begin
    member = bridesmaid_user_profile.members.where(
      email: current_spree_user.email
    ).first

    if member.present?
      member.variant_id = params[:id]
      member.size = Spree::Variant.size_option_type.option_values.where(name: params[:size]).try(:id)
      member.color_id = Spree::Variant.color_option_type.option_values.where(name: params[:color]).try(:id)
      member.save!
    end

    moodboard_owner.moodboard_items.where(variant_id: params[:id]).exists?

    # add this item to bride moodboard
    #bridesmaid_user_profile.spree_user.moodboard_items.

    respond_with(member)
  end
=end
