module Spree
  module Quadpay
    class QuadpayController < ApplicationController

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
        if @order && payment_method && payment_method.kind_of?(Spree::Gateway::QuadpayPayment)
          # puts "mmmmmmmm"
          # puts quadpay_confirm_path(:payment_method_id => params[:payment_method_id])
          # puts quadpay_cancel_path(:payment_method_id => params[:payment_method_id])
          # puts quadpay_notify_path(:payment_method_id => params[:payment_method_id])

          #如果之前的订单支付成功了，我们就不继续支付了，直接转到支付完成页面
          previous_payment = order.payments.find{|x| x.payment_method_id == payment_method.id }
          previous_qp_order_obj = previous_payment&.quadpay_order
          if previous_qp_order_obj
            quadpay_order_info = payment_method.find_order(previous_qp_order_obj.qp_order_id)
            if quadpay_order_info && quadpay_order_info["orderStatus"] == "Approved"
              complete_payment(previous_payment)
              return
            end
          end

          #新建Quadpay订单，开始支付
          qp_order = payment_method.create_order(@order,
                                                 quadpay_confirm_url(:payment_method_id => params[:payment_method_id]),
                                                 quadpay_cancel_url(:payment_method_id => params[:payment_method_id]),
                                                 quadpay_notify_url(:payment_method_id => params[:payment_method_id]))
          if qp_order
            payment = previous_payment || order.payments.create!({ :amount => @order.total.to_f,
                                                                   :payment_method => payment_method,
                                                                   :response_code => qp_order[:orderId]
                                                                 }, :without_protection => true)
            qp_order_obj = payment.nil? ? nil : Spree::QuadpayOrder.create!({payment_id: payment.id,
                                                                             qp_order_id:qp_order['orderId'],
                                                                             qp_order_token:qp_order['token']
                                                                            }, :without_protection => true)
            if payment
              #更新Payment和QP_Order的关系
              payment.response_code = qp_order['orderId']
              payment.amount = @order.total.to_f
              payment.source = qp_order_obj
              payment.save!
              redirect_to qp_order[:redirectUrl]
            else
              flash[:error] = "Quapay payment failed(5), order number: #{@order.number}"
              redirect_to checkout_state_path(:payment)
            end
          else
            flash[:error] = "Quapay payment failed(6), order number: #{@order.number}"
            redirect_to checkout_state_path(:payment)
          end
        else
          flash[:error] = "Quapay payment failed(7), order number: #{@order.number}"
          redirect_to checkout_state_path(:payment)
        end
      end

      def completion_route
        order_path(@order)
      end

      def complete_payment(payment)
          payment.complete!
          # Force complete order
          while @order.next; end

          if @order.completed?
            @current_order = nil
            flash['order_completed'] = true
            flash[:notice] = "The order has been paid successfully."
            return redirect_to completion_route
          else
            flash[:error] = "Quapay payment failed(4), order number: #{@order.number}"
            return redirect_to checkout_state_path(@order.state)
          end
      end

      def confirm
        puts "tttttttttttt" + params.to_s
        order = @current_order
        qp_order_obj = Spree::QuadpayOrder.find_by_qp_order_token(params[:token])
        payment = qp_order_obj&.payment
        if payment
          payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
          quadpay_order_info = payment_method.find_order(qp_order_obj.qp_order_id)

          if quadpay_order_info['orderStatus'] == 'Approved'
            complete_payment(payment)
          else
            flash[:error] = "Quapay payment failed(1), order number: #{@order.number}(#{qp_order_obj.qp_order_id})"
            return redirect_to checkout_state_path(@order.state)
          end
        else
          flash[:error] = "Quapay payment failed(2), order number: #{@order.number}(#{qp_order_obj&.qp_order_id})"
          return redirect_to checkout_state_path(@order.state)
        end
      end

      def cancel
        puts "uuuuuuuuuuuu"
        # puts params.to_s
        flash[:notice] = "Don't want to use Quadpay? No problems."
        redirect_to checkout_state_path(current_order.state)
      end

      def notify
        # puts "eeeeeeeeeeee"
        # puts params.to_s
      end
    end
  end
end
