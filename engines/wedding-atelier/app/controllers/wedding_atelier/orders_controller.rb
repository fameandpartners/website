module WeddingAtelier
  class OrdersController < ApplicationController

    def create
      dress = WeddingAtelier::EventDress.find(params[:dress_id])
      order_attrs = {
        order: current_order(true),
        site_version: current_site_version,
        currency: current_currency,
        product: {
          variant_id: dress.product.master.id,
          size_id: nil,
          color_id: dress.color_id,
          customizations_ids: dress.customizations_ids,
          height: nil,
          quantity: 1
        }
      }
      params[:profiles].each do |key, profile|
        if profile.has_key?(:id)
          profile = Spree::User.find(profile[:id]).user_profile
          height = WeddingAtelier::Height.height_group(profile.height)
        else
          height = profile[:height]
        end
        order_attrs[:product][:size_id] = profile[:dress_size_id]
        order_attrs[:product][:height] = height
        result = UserCart::Populator.new(order_attrs).populate
        unless result.success
          NewRelic::Agent.notify('AddToCartFailed',
                                 message: result.message,
                                 order_number: current_order.number,
                                 site_version: current_site_version.code,
                                 attrs: result.attrs)

          render json: {error: true, message: result.message, attrs: result.attrs}, status: :unprocessable_entity and return
        end
      end
      render json: current_order, serializer: WeddingAtelier::OrderSerializer
    end

    def show
      render json: current_order, serializer: WeddingAtelier::OrderSerializer
    end
  end
end
