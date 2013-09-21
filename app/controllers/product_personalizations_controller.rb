class ProductPersonalizationsController < ApplicationController
  def create
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    @personalization = ProductPersonalization.new(params[:product_personalization])
    @personalization.user = current_spree_user if spree_user_signed_in?

    if @personalization.valid? && populator.populate(variants: { @personalization.variant_id => 1 })
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload

      @personalization.line_item = current_order.line_items.find_by_variant_id(@personalization.variant_id)

      @personalization.save

      product = Spree::Variant.where(id: @personalization.variant_id).first.try(:product)

      Activity.log_product_added_to_cart(product, temporary_user_key, try_spree_current_user, current_order) rescue nil
    end
  end
end
