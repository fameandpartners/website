module Spree
  module Quadpay
    class QuadpayController < ApplicationController

      #include SslRequirement
      #ssl_allowed

      def express
        payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
        @order = current_order
        if @order && payment_method && payment_method.kind_of?(Spree::Gateway::QuadpayPayment)
          # puts "mmmmmmmm"
          # puts quadpay_confirm_path(:payment_method_id => params[:payment_method_id])
          # puts quadpay_cancel_path(:payment_method_id => params[:payment_method_id])
          # puts quadpay_notify_path(:payment_method_id => params[:payment_method_id])

          #如果之前的订单支付成功了，我们就不继续支付了，直接转到支付完成页面
          @order.payments.each do |py|
            puts "payment:" + py.to_s
          end
          previous_payment = @order.payments.find{|x| x.payment_method_id == payment_method.id }
          previous_qp_order_obj = previous_payment&.quadpay_order
          if previous_qp_order_obj
            quadpay_order_info = payment_method.find_order(previous_qp_order_obj.qp_order_id)
            if quadpay_order_info && quadpay_order_info["orderStatus"] == "Approved"
              if complete_order_and_payment(previous_payment, @order, !signed_in?)
                flash[:commerce_tracking] = 'nothing special'
                session[:successfully_ordered] = true
                flash['order_completed'] = true
                flash[:notice] = "The order has been paid successfully."
                return redirect_to completion_route
              else
                flash[:error] = "Quapay payment failed(4), order number: #{@order.number}"
                return redirect_to checkout_state_path(@order.state)
              end
            end
          end

          #新建Quadpay订单，开始支付
          qp_order = payment_method.create_order(@order,
                                                 quadpay_confirm_url(:payment_method_id => params[:payment_method_id]),
                                                 quadpay_cancel_url(:payment_method_id => params[:payment_method_id]),
                                                 quadpay_notify_url(:payment_method_id => params[:payment_method_id]))
          if qp_order
            payment =  previous_payment || @order.payments.create!({ :amount => @order.total.to_f,
                                                                   :payment_method => payment_method,
                                                                   :response_code => qp_order['orderId']
                                                                 }, :without_protection => true)
            if previous_payment
              puts "previous payment1: " + previous_payment.id.to_s + "state: " + previous_payment.state.to_s
            else
              puts "payment2: " + payment.id.to_s + "state: " + payment.state.to_s
            end
            puts "payment:" + payment.id.to_s + " response code4:" + (payment.response_code.nil? ? "" : payment.response_code)
            qp_order_obj = payment.nil? ? nil : Spree::QuadpayOrder.create!({:payment_id => payment.id,
                                                                             :qp_order_id => qp_order['orderId'],
                                                                             :qp_order_token => qp_order['token']
                                                                            }, :without_protection => true)
            puts 'qp_order' + qp_order.to_s
            if payment
              #更新Payment和QP_Order的关系
              puts "payment:" + payment.id.to_s + " response code6:" + (payment.response_code.nil? ? "" : payment.response_code)
              payment.response_code = qp_order['orderId']
              puts "payment:" + payment.id.to_s + " response code7:" + (payment.response_code.nil? ? "" : payment.response_code)
              payment.amount = @order.total.to_f
              payment.source = qp_order_obj
              payment.save!
              puts "payment:" + payment.id.to_s + " response code9:" + (payment.response_code.nil? ? "" : payment.response_code)
              puts qp_order['redirectUrl']
              puts qp_order[:redirectUrl].to_s
              redirect_to qp_order['redirectUrl']
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

      # def complete_payment(payment)
      #   puts "complete payment: " + (payment.id.nil? ? "" : payment.id.to_s)
      #   puts "payment state: " + payment.state.to_s
      #   update_order_steps
      #   puts "payment:" + payment.id.to_s + " response code1:" + (payment.response_code.nil? ? "" : payment.response_code)
      #   payment.update_qp_order_id
      #   if payment.state != "completed"
      #     payment.complete!
      #   end
      #   puts "payment:" + payment.id.to_s + " response code2:" + (payment.response_code.nil? ? "" : payment.response_code)
      #
      #   #@order.next
      #   # 强制完成
      #   if @order.state != "complete"
      #     @order.completed_at = Time.now.utc.to_s
      #     @order.state = "complete"
      #     @order.save!
      #   end
      #   puts "payment:" + payment.id.to_s + " response code3:" + (payment.response_code.nil? ? "" : payment.response_code)
      #   if @order.completed?
      #     OrderBotWorker.perform_async(@order.id)
      #     flash[:commerce_tracking] = 'nothing special'
      #     session[:successfully_ordered] = true
      #     flash['order_completed'] = true
      #     flash[:notice] = "The order has been paid successfully."
      #     return redirect_to completion_route
      #   else
      #     flash[:error] = "Quapay payment failed(4), order number: #{@order.number}"
      #     return redirect_to checkout_state_path(@order.state)
      #   end
      # end

      def confirm

        puts "tttttttttttt" + params.to_s
        @order = current_order
        qp_order_obj = Spree::QuadpayOrder.find_by_qp_order_token(params[:token])
        payment = qp_order_obj&.payment
        puts "payment:" + payment.id.to_s + " response code8:" + (payment.response_code.nil? ? "" : payment.response_code)
        if payment
          payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
          quadpay_order_info = payment_method.find_order(qp_order_obj.qp_order_id)

          if quadpay_order_info['orderStatus'] == 'Approved'
            if complete_order_and_payment(previous_payment, @order, !signed_in?)
              flash[:commerce_tracking] = 'nothing special'
              session[:successfully_ordered] = true
              flash['order_completed'] = true
              flash[:notice] = "The order has been paid successfully."
              return redirect_to completion_route
            else
              flash[:error] = "Quapay payment failed(8), order number: #{@order.number}"
              return redirect_to checkout_state_path(@order.state)
            end
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

      # def update_order_steps
      #   order = current_order
      #
      #   if !signed_in? # 'personal'
      #     update_order_personal_info
      #   end
      #
      #   if !order.has_checkout_step?("address") || order.bill_address.blank? || order.shipping_address.blank?
      #     update_order_addresses
      #   end
      #
      #   order.state = 'payment'
      #   order.save
      # end
      #
      # protected
      #
      # def update_order_personal_info
      #   order = current_order
      #
      #   user = order.user
      #   if user.nil?
      #     build_user(order)
      #   end
      #
      #   complete_order_step(order, 'cart')
      # end
      #
      # # populate shipping/billing with paypal info, in case of 'cart checkout' / 'checkout from page'
      # def update_order_addresses
      #   order = current_order
      #   if order.bill_address.blank? && !order.shipping_address.blank?
      #     order.bill_address = order.shipping_address
      #     complete_order_step(order, 'address')
      #   end
      # end
      #
      # # state machine states have
      # def complete_order_step(order, order_step)
      #   original_state = order.state
      #   order.state = order_step
      #
      #   if !order.next
      #     order.state = original_state
      #     order.save(validate: false) # store data from paypal. user will be redirect to 'personal' tab
      #   end
      # end
      #
      # private
      # def build_user(order)
      #   if order
      #     Spree::User.new(
      #       email: order.email,
      #       first_name: order.shipping_address.firstname,
      #       last_name: order.shipping_address.lastname,
      #       password: order.number,
      #       password_confirmation: order.number
      #     )
      #   else
      #     Spree::User.new()
      #   end
      # end
    end
  end
end
