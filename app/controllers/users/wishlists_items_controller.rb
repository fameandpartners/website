class Users::WishlistsItemsController < Users::BaseController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::Common

  before_filter :load_user

  def index
    @moodboard = Wishlist::UserWishlistResource.new(
      site_version: current_site_version,
      owner: current_spree_user
    ).read

    @title = @moodboard.title

    respond_with(@moodboard) do |format|
      format.html {}
      format.js   {}
    end
  end

  # { product_id: 1, color_id: 2, variant_id: 3, quantity: 1 }
  def create
    # add colored variant
    add_as_colored_product = params[:product_id].present? && params[:color_id].present?
    add_as_colored_product &&= ProductColorValue.where(
      product_id: params[:product_id], option_value_id: params[:color_id]
    ).exists?

    if add_as_colored_product
      @item = @user.wishlist_items.where(
        spree_product_id: params[:product_id],
        product_color_id: params[:color_id]
      ).first_or_initialize
      @item.spree_variant_id = params[:variant_id]
      @item.quantity = params[:quantity]
      @item.save
    else
      # add variant [ mostly, this will be master variant ]
      variant = Spree::Variant.find(params[:variant_id])

      @item = @user.wishlist_items.where(spree_product_id: variant.product_id).first
      @item ||= @user.wishlist_items.create(
        spree_variant_id: variant.id,
        spree_product_id: variant.product_id,
        spree_color_id: variant.dress_color.try(:id),
        quantity: params[:quantity]
      )
    end

    if @item.persisted?
      render json: {
        item: WishlistItemSerializer.new(@item).to_json,
        analytics_label: analytics_label(:product, @item.product)
      }
    else
      render json: {}
    end
  end

  def destroy
    @item = @user.wishlist_items.find_by_id(params[:id])
    @item.try(:destroy)

    respond_with({}) do |format|
      format.html { redirect_to wishlist_path }
      format.js   {}
      format.json {
        if @item.present?
          render json: {
            item: WishlistItemSerializer.new(@item).to_json,
            analytics_label: analytics_label(:product, @item.try(:product))
          }
        else
          render json: {}
        end
      }
    end
  end

  # id - wishlist item id
  # variant_id - custom dress variant ( can differs from wishlist item.variant_id )
  def move_to_cart
    @item = @user.wishlist_items.find(params[:id])

    populator = Spree::OrderPopulator.new(current_order(true), current_currency)
    if params[:variant_id] && params[:quantity]
      populate_options = { params[:variant_id].to_i =>  params[:quantity].to_i }
    else
      populate_options = { @item.variant.id => @item.quantity }
    end

    if populator.populate(variants: populate_options)
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload

      @item.destroy
    end

    respond_with(@item) do |format|
      format.html { redirect_to wishlist_path }
      format.js   {}
    end
  end
end
