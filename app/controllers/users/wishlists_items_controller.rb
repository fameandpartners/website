class Users::WishlistsItemsController < Users::BaseController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::Common

  before_filter :load_user

  def index
    @items = @user.wishlist_items
    respond_with(@items) do |format|
      format.html {}
      format.js   {}
    end
  end

  # {"variant_id"=>"1240", "quantity"=>"1"}
  def create
    variant = Spree::Variant.find(params[:variant_id])

    @item = @user.wishlist_items.where(spree_product_id: variant.product_id).first
    @item ||= @user.wishlist_items.create(
      spree_variant_id: variant.id,
      spree_product_id: variant.product_id,
      quantity: params[:quantity]
    )

    if @item.persisted?
      render json: @item
    else
      render json: {}
    end
  end

  def destroy
    @item = @user.wishlist_items.find(params[:id])
    @item.destroy

    respond_with(@item) do |format|
      format.html { redirect_to wishlist_path }
      format.js   {}
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
