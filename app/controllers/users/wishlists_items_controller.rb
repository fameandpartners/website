class Users::WishlistsItemsController < Users::BaseController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::Common

  before_filter :load_user

  layout 'redesign/application'

  # NOTE: Alexey Bobyrev 09/12/16
  # Oh boy! This should be urgent one!
  # We need to rewrite it ASAP to avoid leaving Whishlist namespace w/o control щ（ﾟДﾟщ）
  # {"color_id"=>"184", "variant_id"=>"19258", "product_id"=>"97"}
  def create
    moodboard_populator = UserMoodboard::Populator.new(
      user: current_spree_user,
      product_id: params[:product_id],
      variant_id: params[:variant_id],
      color_id: params[:color_id]
    )

    moodboard_populator.populate

    render json: current_user_moodboard
  end

  # TODO - Re-implement this functionality in new moodboards
  # id - wishlist item id
  # variant_id - custom dress variant ( can differs from wishlist item.variant_id )
  # def move_to_cart
  #   @item = @user.wishlist_items.find(params[:id])
  #
  #   populator = Spree::OrderPopulator.new(current_order(true), current_currency)
  #   if params[:variant_id] && params[:quantity]
  #     populate_options = { params[:variant_id].to_i =>  params[:quantity].to_i }
  #   else
  #     populate_options = { @item.variant.id => @item.quantity }
  #   end
  #
  #   if populator.populate(variants: populate_options)
  #     fire_event('spree.cart.add')
  #     fire_event('spree.order.contents_changed')
  #
  #     current_order.reload
  #
  #     @item.destroy
  #   end
  #
  #   #Repositories::UserWishlist.new(owner: current_spree_user).drop_cache
  #
  #   respond_with(@item) do |format|
  #     format.html { redirect_to wishlist_path }
  #     format.js   {}
  #   end
  # end
end
