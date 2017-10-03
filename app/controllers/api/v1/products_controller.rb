module Api
  module V1
    class ProductsController < Spree::Api::BaseController
      respond_to :json
      # include SslRequirement
      # ssl_allowed
      # include Errors::Sentry::ControllerConcern

      include Spree::Core::ControllerHelpers::Order
      include Spree::Core::ControllerHelpers::Auth
      # include Concerns::SiteVersion
      # include Spree::Core::ControllerHelpers::Common
      # include ApplicationHelper
      # # include PathBuildersHelper
      # include Concerns::SiteVersion


      # GET
      def create
        binding.pry
        cart = UserCart::CartProduct.new({
          order: current_order(true)
        })
        populated_cart = cart.populate_cart(params)
        binding.pry
        # cart_populator = UserCart::Populator.new(
        #   order: current_order(true),
        #   site_version: current_site_version,
        #   currency: current_currency,
        #   product: {
        #     variant_id: params[:variant_id],
        #     size_id: params[:size_id],
        #     color_id: params[:color_id],
        #     customizations_ids: params[:customizations_ids],
        #     making_options_ids: params[:making_options_ids],
        #     height:             params[:height],
        #     height_value:       params[:height_value],
        #     height_unit:        params[:height_unit],
        #     quantity: 1
        #   }
        # )
        # binding.pry
        result = cart_populator.populate

        if result.success
          if spree_user_signed_in? && current_order.user.nil?
            self.extend(Spree::Core::ControllerHelpers::Order)
            associate_user
          end

          if current_promotion.present?
            promotion_service = UserCart::PromotionsService.new(
              order: current_order,
              code:  current_promotion.code
            )

            if promotion_service.apply
              fire_event('spree.order.contents_changed')
              fire_event('spree.checkout.coupon_code_added')
            end
          end

          @user_cart = user_cart_resource.read

          data = add_analytics_labels(@user_cart.serialize)

          # flash[:variant_id_added_to_cart] = params[:dress_variant_id].presence
          # respond_with(@user_cart) do |format|
          #   format.json   {
          render json: data, status: :created
            # }
          # end
        else # not success
          NewRelic::Agent.notify('AddToCartFailed',
                                 message: result.message,
                                 order_number: current_order.number,
                                 site_version: current_site_version.code,
                                 attrs: result.attrs)
          respond_with({}) do |format|
            format.json   {
              render json: { error: true, message: result.message, attrs: result.attrs }, status: 422
            }
          end
        end
      end

    end
  end
end
