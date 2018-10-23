module Api
    module V1
      class CartController < ApplicationController 
        respond_to :json
        skip_before_filter :verify_authenticity_token

        def restore
            cart_id = params[:cart_id]
            cart = Bronto::CartRestorationService.restore(cart_id)

            unless cart.nil?
                render :json => {:success=>true, :cart=>cart}, status: 200
            else
                render :json => {:success=>false}, status: 400
            end
        end
      end
    end
  end
  