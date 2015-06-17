class Users::WishlistsItemsController < Users::BaseController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::Common

  before_filter :load_user


  layout 'redesign/application'
  
  def index
    @moodboard = Wishlist::UserWishlistResource.new(
      site_version: current_site_version,
      owner: current_spree_user
    ).read

    @title = @moodboard.title

    if current_promotion && (auto_discount = current_promotion.discount)
      @moodboard.products.each do |product|
        product.discount = [product.discount, auto_discount].compact.max_by{|i| i.amount}
      end
    end

    respond_with(@moodboard) do |format|
      format.html {}
      format.js   {}
    end
  end

  # {"color_id"=>"184", "variant_id"=>"19258", "product_id"=>"97"}
  def create
    moodboard_populator = UserMoodboard::Populator.new(
      user: current_spree_user,
      product_id: params[:product_id],
      variant_id: params[:variant_id],
      color_id: params[:color_id]
    )

    moodboard_populator.populate

    render json: current_user_moodboard.serialize.to_json
  #rescue Exception => e
  #  render json: {}, status: :error
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

    #Repositories::UserWishlist.new(owner: current_spree_user).drop_cache

    respond_with(@item) do |format|
      format.html { redirect_to wishlist_path }
      format.js   {}
    end
  end
end
