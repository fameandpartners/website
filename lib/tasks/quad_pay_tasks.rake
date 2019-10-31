#require File.expand_path('../../../app/helpers/spree/quadpay_complete_helper',__FILE__)
#require File.expand_path('../../../app/helpers/spree/quad_pay_helper',__FILE__)
#include File.expand_path('../../../app/helpers/spree/quad_pay_helper',__FILE__)

namespace :quad_pay_tasks do
  task sync_orders: :environment do
    #qpms = Spree::BillingIntegration::QuadPayCheckout.available_on_front_end.active
    payment_method = Spree::Gateway::QuadpayPayment.payment_method #quadpaypaymentmethod
    #qpms = Spree::PaymentMethod.available_on_front_end.active
    #if qpm = qpms.first
    pid = payment_method.id
    qpms = quadpay_payments(pid)
    qpms = qpms.to_a

    if qpms.nil?   then
      puts "qpms is nil"
    else
      puts "qpms count = " + qpms.count.to_s

      qpms.each do |payment|
        order = payment.order

        qp_order_in_db = payment.quadpay_order
        if qp_order_in_db.nil? then
          puts "payment.quadpay_order is nil order is = " + order.to_s
          next
        end

        qp_order_id = qp_order_in_db.qp_order_id

        if qp_order_id.nil? then
          puts "token is nil order is = " + order.to_s
        else
          quadpay_order_from_api = payment_method.find_order(qp_order_id)#qpm.find_order(payment.response_code)
          #next if quadpay_order.nil?
          if quadpay_order_from_api.nil? || quadpay_order_from_api.blank? then
            puts "quadpay_order_from_api is nil, order = " + order.to_s
          else
            puts quadpay_order_from_api.to_json.to_s

            #Spree::QuadPayHelper::complete_order_and_payment(payment, order, order.user.nil?)
            case quadpay_order_from_api['orderStatus']
            when 'Created'
              # No action
            when 'Approved'
              # payment.update(state: 'processing')
              # payment.complete!
              # # Force complete order
              # while order.next; end
              Spree::QuadPayHelper::complete_order_and_payment(payment, order, order.user.nil?)
            when 'Declined'
              make_payment_fail(payment)
            when 'Abandoned'
              make_payment_fail(payment)
            else
              make_payment_fail(payment) if payment.created_at < 15.minute.ago #other status 15 minute before
            end
          end#if quadpay_order_from_api.nil?
        end #if token nil
      end#each do
    end#if nil
  end

  def make_payment_fail(payment)
    payment.update_attributes({:state => "processing"}, :without_protection => true)
    payment.failure
  end

  #15.minute.ago
  def quadpay_payments(method_id)
    Spree::Payment.
      readonly(false).
      where(:payment_method_id => method_id).
      joins(:order).
      where('spree_payments.state not IN (?)', %w(failed completed)).
      where('spree_payments.created_at >= ?', 2.days.ago)
  end

  def complete_payment(payment, order)
    puts "complete payment: " + (payment.id.nil? ? "" : payment.id.to_s)
    puts "payment state: " + payment.state.to_s
    update_order_steps
    puts "payment:" + payment.id.to_s + " response code1:" + (payment.response_code.nil? ? "" : payment.response_code)
    payment.update_qp_order_id
    if payment.state != "completed"
      payment.complete!
    end
    puts "payment:" + payment.id.to_s + " response code2:" + (payment.response_code.nil? ? "" : payment.response_code)

    #@order.next
    # 强制完成
    if @order.state != "complete"
      @order.completed_at = Time.now.utc.to_s
      @order.state = "complete"
      @order.save!
    end
    puts "payment:" + payment.id.to_s + " response code3:" + (payment.response_code.nil? ? "" : payment.response_code)
    if @order.completed?
      OrderBotWorker.perform_async(@order.id)
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

  #def quad_pay_payments(qpms)
  #  Spree::Payment.
  #    where(payment_method_id: qpms.ids).
  #    joins(:order).
  #    where.not('spree_payments.state IN (?)', %w(failed completed)).
  #    where('spree_payments.created_at >= ?', 15.minutes.ago)
  #  end

end
