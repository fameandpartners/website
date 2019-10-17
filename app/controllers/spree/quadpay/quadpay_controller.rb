module Spree
  module Quadpay
    class QuadpayController < ApplicationController
      def find_or_create_quadpay_payment(order, amount, payment_method, order_Id)
        order.payments.find {|x| x.payment_method_id == payment_method.id } ||
          order.payments.create!({ :amount => amount,
                                   :payment_method => payment_method,
                                   :response_code => order_Id
                                 },:without_protection => true)
      end

      def express
        items = current_order.line_items.map do |item|
          {
            :Name => item.product.name,
            :Quantity => item.quantity,
            :Amount => {
              :currencyID => current_order.currency,
              :value => item.price
            },
            :ItemCategory => "Physical"
          }
        end

        tax_adjustments = current_order.adjustments.tax
        shipping_adjustments = current_order.adjustments.shipping

        current_order.adjustments.eligible.each do |adjustment|
          next if (tax_adjustments + shipping_adjustments).include?(adjustment)
          items << {
            :Name => adjustment.label,
            :Quantity => 1,
            :Amount => {
              :currencyID => current_order.currency,
              :value => adjustment.amount
            }
          }
        end

        # Because PayPal doesn't accept $0 items at all.
        # See #10
        # https://cms.paypal.com/uk/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_ECCustomizing
        # "It can be a positive or negative value but not zero."
        items.reject! do |item|
          item[:Amount][:value].zero?
        end

        payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
        @order = current_order
        if !@order.nil? && payment_method && payment_method.kind_of?(Spree::Gateway::QuadpayPayment)
          # puts "mmmmmmmm"
          # puts quadpay_confirm_path(:payment_method_id => params[:payment_method_id])
          # puts quadpay_cancel_path(:payment_method_id => params[:payment_method_id])
          # puts quadpay_notify_path(:payment_method_id => params[:payment_method_id])
          if qp_order = payment_method.create_order(@order,
                                                    quadpay_confirm_url(:payment_method_id => params[:payment_method_id]),
                                                    quadpay_cancel_url(:payment_method_id => params[:payment_method_id]),
                                                    quadpay_notify_url(:payment_method_id => params[:payment_method_id]))
            payment = find_or_create_quadpay_payment(@order, 1000, payment_method, qp_order['orderId'])
            qp_order_model = payment.nil? ? nil : Spree::QuadpayOrder.create!({payment_id: payment.id, qp_order_id:qp_order['orderId'],qp_order_token:qp_order['token']}, :without_protection => true)
            if !payment.nil?
              payment.source = qp_order_model
              payment.save!
              redirect_to qp_order['redirectUrl']
            else
              flash[:error] = "Quapay Payment failed."
              redirect_to checkout_state_path(:payment)
            end
          else
            flash[:error] = "Quapay Order failed."
            redirect_to checkout_state_path(:payment)
          end
        else
          flash[:error] = Spree.t(:quad_pay_checkout_error)
          redirect_to checkout_state_path(:payment)
        end
      end

      def confirm
        puts "tttttttttttt"
        puts params.to_s
        if @quadpay_order.body['orderStatus'] == 'Approved'
          @payment.complete!
          # Force complete order
          while @order.next; end

          if @order.completed?
            @current_order = nil
            flash['order_completed'] = true
            flash[:notice] = "#{Spree.t(:quadpay_payment_success)} #{Spree.t(:order_processed_successfully)}"
            return go_to_order_page
          else
            flash[:error] = Spree.t(:quadpay_payment_fail, number: @order.number)
            return redirect_to checkout_state_path(@order.state)
          end
        else
          flash[:error] = Spree.t(:quadpay_payment_fail, number: @order.number)
        end
        return go_to_order_page
      end

      def cancel
        puts "uuuuuuuuuuuu"
        puts params.to_s
        flash[:notice] = "Don't want to use Quadpay? No problems."
        redirect_to checkout_state_path(current_order.state)
      end

      def notify
        puts "eeeeeeeeeeee"
        puts params.to_s
      end
    end
  end
end
