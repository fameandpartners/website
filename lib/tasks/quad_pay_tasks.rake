namespace :quad_pay_tasks do
  task sync_orders: :environment do
    #qpms = Spree::BillingIntegration::QuadPayCheckout.available_on_front_end.active
    payment_method = Spree::Gateway::QuadpayPayment.payment_method
    #qpms = Spree::PaymentMethod.available_on_front_end.active
    #if qpm = qpms.first
    pid = payment_method.id
    qpms = quadpay_payments(pid)

    if qpms.nil?   then
      puts "qpms is nil"
    else
        qpms.each do |payment|
          order = payment.order
          token = payment.quadpay_order&.qp_order_token
          if token.nil? then
            puts "token is nil order is = " + order.to_s
          else
            quadpay_order = payment_method.find_order(token)#qpm.find_order(payment.response_code)
            #next if quadpay_order.nil?
            if quadpay_order.nil? then
              puts "quard pay order is nil, order = " + order.to_s
            else
              puts quadpay_order.to_json.to_s
              if quadpay_order.code == 200
                case quadpay_order.body['orderStatus']
                when 'Created'
                  # No action
                when 'Approved'
                  payment.update(state: 'processing')
                  payment.complete!
                  # Force complete order
                  while order.next; end
                when 'Declined'
                  make_payment_fail(payment)
                when 'Abandoned'
                  make_payment_fail(payment)
                else
                  make_payment_fail(payment) if payment.created_at < 15.minute.ago #other status 15 minute before
                end
              else
                make_payment_fail(payment) if payment.created_at < 15.minute.ago #if code!=200 15 minute before
              end
            end#if quardpay_order.nil?
          end #if token nil
      end#each do
    end#if nil
  end

  def make_payment_fail(payment)
    payment.update(state: 'processing')
    payment.failure
  end

  def quadpay_payments(method_id)
    Spree::Payment.
      where(:payment_method_id => method_id).
      joins(:order).
      where('spree_payments.state not IN (?)', %w(failed completed)).
      where('spree_payments.created_at >= ?', 10.days.ago)
  end
end
