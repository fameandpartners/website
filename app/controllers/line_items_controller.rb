class LineItemsController < Spree::StoreController
  respond_to :json
  respond_to :js, only: [:create]

  def create
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1

    @product = Spree::Variant.where(id: params[:variant_id]).first.try(:product)

    if params[:line_item_personalization].present?
      @personalization = LineItemPersonalization.new(params[:line_item_personalization])
      @personalization.product = @product
    end

    if @personalization.blank? && populator.populate(variants: { params[:variant_id] => quantity })
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload
    elsif @personalization.try(:valid?)
      populator.populate_personalized = true
      unless current_order.line_items.find_by_variant_id(params[:variant_id]).present?
        if populator.populate(variants: { params[:variant_id] => quantity })
          fire_event('spree.cart.add')
          fire_event('spree.order.contents_changed')

          current_order.reload
        end
      end
    end

    if current_promotion.present?
      @order = current_order
      @order.update_attributes(coupon_code: current_promotion.code)
      apply_coupon_code
      fire_event('spree.order.contents_changed')
      current_order.reload
    end

    @line_item = current_order.line_items.find_by_variant_id(params[:variant_id])

    if @personalization.present? && @line_item.present?
      @line_item.personalization.try(:destroy)
      @personalization.line_item = @line_item
      @personalization.save
      current_order.update!
      current_order.reload
    end

    associate_user if spree_user_signed_in?

    respond_with @line_item do |format|
      format.json do
        render json: {
          order: CartSerializer.new(current_order).to_json,
          analytics_label: analytics_label(:product, @product)
        }
      end
      format.js do
        render :create
      end
    end
  end

  # edit item in cart
  def edit
    raise "can't find without an id" if params[:id].blank?

    line_item = current_order.line_items.find(params[:id])
    @product_variants = Products::VariantsReceiver.new(line_item.variant.product_id).available_options

    render json: {
      variants: @product_variants,
      line_item: LineItemSerializer.new(line_item)
    }
  end

  # id: line-item-imd
  # params[:variant_id]
  # params[:quantity]
  def update
    line_item = current_order.line_items.find(params[:id])
    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
    variant = Spree::Variant.find(params[:variant_id])

    current_order.update_line_item(line_item, variant, quantity, currency = nil)

    render json: { order: CartSerializer.new(current_order).to_json }
  end

  # params[:id]
  def move_to_wishlist
    user = try_spree_current_user
    line_item = current_order.line_items.where(id: params[:id]).first
    variant = line_item.variant

    status = :bad_request

    if line_item
      wishlist_item = user.wishlist_items.where(spree_product_id: variant.product_id).first
      wishlist_item ||= user.wishlist_items.create(
        spree_variant_id: variant.id,
        spree_product_id: variant.product_id,
        quantity: line_item.quantity
      )
      if wishlist_item.persisted?
        line_item.destroy
        status = :ok
        Repositories::UserWishlist.new(owner: current_spree_user).drop_cache
      end
    end
    current_order.reload

    json_result = {
      order: CartSerializer.new(current_order).to_json,
      analytics_label: analytics_label(:product, variant.product)
    }
    render json: json_result, status: status
  rescue
    render json: {}, status: :bad_request
  end

  # order_id
  # variant_id
  def destroy
    line_item = current_order.line_items.where(variant_id: params[:variant_id]).first
    line_item.try(:destroy)
    current_order.reload
    render json: { order: CartSerializer.new(current_order).to_json}, status: :ok
  end

  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
  end
end
