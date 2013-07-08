class Users::WishlistsItemsController < Users::BaseController
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
    @item = @user.wishlist_items.where(spree_variant_id: params[:variant_id]).first_or_create

    render json: @item
  end

  def destroy
    @item = @user.wishlist_items.find(params[:id])
    @item.destroy

    respond_with(@item) do |format|
      format.html { redirect_to wishlist_path }
      format.js   {}
    end
  end

  def move_to_cart
    @item = @user.wishlist_items.find(params[:id])

    populator = Spree::OrderPopulator.new(current_order(true), current_currency)
    if populator.populate(variants: { @item.variant.id => 1 })
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload
    end

    respond_with(@item) do |format|
      format.html { redirect_to wishlist_path }
      format.js   {}
    end
  end
end
