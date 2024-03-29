module Spree
  module QuadPayHelper
    QUADPAY_WIDGET_URL_BASE = "https://widgets.quadpay.com"

    def quadpay_active_on_front_end?
      Spree::BillingIntegration::QuadPayCheckout.available_on_front_end.exists?(active: true)
    end

    def display_quadpay_widget_on_product_page?
      return false unless quadpay_active_on_front_end?

      Spree::Config.quad_pay_display_widget_at_product_page
    end

    def display_quadpay_widget_on_cart_page?
      return false unless current_order
      return false unless quadpay_active_on_front_end?

      Spree::Config.quad_pay_display_widget_at_cart_page
    end

    def display_quadpay_widget_on_checkout_page?
      return false unless current_order
      return false unless quadpay_active_on_front_end?

      Spree::Config.quad_pay_display_widget_at_checkout_process
    end

    def quadpay_product_widget(product_price)
      return '' unless product_price

      order_total = current_order ? current_order.total.to_f : 0

      quadpay_widget(
        amount: product_price,
        future_order_total: order_total + product_price
      )
    end

    def quadpay_cart_widget
      return '' unless current_order

      quadpay_widget(
        amount: current_order.total,
        future_order_total: current_order.total
      )
    end

    def quadpay_widget(amount:, future_order_total:)
      min_amount = Spree::Config.quad_pay_min_amount.to_f
      max_amount = Spree::Config.quad_pay_max_amount.to_f

      installment_amount = (amount / 4.0 * 100).to_i / 100.0
      widget_url = quadpay_widget_url

      body = if future_order_total > max_amount
          "on orders <span class='qp--nowrap'>up to #{number_to_currency(max_amount)}</span>"
        elsif future_order_total < min_amount
          "on orders <span class='qp--nowrap'>over #{number_to_currency(min_amount)}</span>"
        else
          "of <span class='qp-descrip__price'>#{number_to_currency(installment_amount)}</span>"
        end

      widget_html = <<-HTML
        <!-- QuadPay Product Page Widget START -->
        <style>
          .qp-container,.qp-quadpay{display:-webkit-box;display:-ms-flexbox}.qp-container{margin:0 0 10px;display:flex;-webkit-box-orient:vertical;-webkit-box-direction:normal;-ms-flex-direction:column;flex-direction:column;-ms-flex-wrap:wrap;flex-wrap:wrap;-webkit-box-pack:center;-ms-flex-pack:center;justify-content:center;-webkit-box-align:start;-ms-flex-align:start;align-items:flex-start;width:100%;min-height:35px;z-index:1}.qp-quadpay,.qp-quadpay__link{-webkit-box-orient:horizontal;-webkit-box-direction:normal}.qp-descrip{margin-bottom:4px}.qp-descrip__price{font-weight:700;margin-left:2px}.qp-quadpay{display:flex;-ms-flex-wrap:nowrap;flex-wrap:nowrap;-ms-flex-direction:row;flex-direction:row;-webkit-box-align:start;-ms-flex-align:start;align-items:flex-start;position:relative;-webkit-box-pack:start;-ms-flex-pack:start;justify-content:flex-start}.qp-quadpay__link{cursor:pointer;display:-webkit-box;display:-ms-flexbox;display:flex;-ms-flex-wrap:nowrap;flex-wrap:nowrap;-ms-flex-direction:row;flex-direction:row}.qp-quadpay__logo{width:90px;margin:.15em 12px 0 6px;position:relative;bottom:-1px}.qp-quadpay__learn{min-width:75px}.qp-quadpay__learn:hover{text-decoration:underline}
        </style>
        <div id="qp-container" class="qp-container">
          <div id="qp-descrip" class="qp-descrip">or 4 interest-free payments #{body}</div>
          <div id="qp-quadpay" class="qp-quadpay">by
            <div id="qp-quadpay__link" class="qp-quadpay__link">
              <div id="qp-quadpay__logo" class="qp-quadpay__logo"><svg version="1.1" width="96" height="15" viewBox="0 0 96 15" xmlns="http://www.w3.org/2000/svg"><title>QuadPay</title><g fill="none" fill-rule="evenodd"><path d="m14.331 11.092l-1.348-1.6237c-0.06583-0.079292-0.16354-0.12517-0.2666-0.12517h-6.9553c-1.8958-0.18262-3.3253-1.6637-3.3253-3.4451 0-1.9098 1.6658-3.4637 3.7131-3.4637 0.089272 0 0.17819 0.0029803 0.2666 0.0088878 0.82947 0.055424 1.6146 0.36851 2.2346 0.89547 0.68467 0.58197 0.93434 1.3741 1.0205 2.2306l0.0029623 0.058259 9.556e-5 1.8504c8.32e-6 0.19136 0.15514 0.34648 0.3465 0.34648l1.8393-1.439e-5c0.19135 0 0.34647-0.15512 0.34647-0.34647 0-1.721e-4 -1e-7 -3.4419e-4 -4e-7 -5.1629e-4 -0.001863-1.2502-0.0036722-1.8882-0.0054277-1.9139-0.1935-3.0289-2.8707-5.4001-6.0949-5.4001-3.3668 0-6.1059 2.5786-6.1059 5.7482 0 2.9809 2.3749 5.441 5.5242 5.7223 0.019494 0.0016034 0.11878 0.0068593 0.57086 0.025299l3.0857 5.345e-4 0.49401 8.91e-5v0.62348 0.70757l6.77e-5 0.45914c1.737e-5 0.11774 0.059823 0.22742 0.15879 0.2912l1.8434 1.1881c0.16085 0.10367 0.37529 0.057311 0.47896-0.10354 0.03609-0.055997 0.055272-0.12121 0.055248-0.18783l-8.276e-4 -2.3544-1.912e-4 -0.62375h0.6691 1.1853c0.19137 0 0.3465-0.15513 0.3465-0.3465 0-0.08084-0.028266-0.15914-0.079904-0.22133z" fill=" #51626f"/><path d="m15.741 7.4022c0 2.4783 2.2212 4.337 4.9671 4.337 2.7634 0 5.0021-1.8587 5.0021-4.337v-6.9293c0-0.16304-0.15741-0.30978-0.3323-0.30978h-2.1512c-0.19239 0-0.3323 0.14674-0.3323 0.30978v6.7989c0 1.1902-0.92695 1.8587-2.1862 1.8587-1.2418 0-2.1512-0.66848-2.1512-1.8587v-6.7989c0-0.16304-0.13992-0.30978-0.3323-0.30978h-2.1512c-0.1749 0-0.3323 0.14674-0.3323 0.30978v6.9293zm11.841 4.1739c-0.26235 0-0.40226-0.21196-0.29733-0.42391l5.4743-10.973c0.052469-0.097826 0.1749-0.17935 0.29733-0.17935h0.1749c0.12243 0 0.24486 0.081522 0.29733 0.17935l5.4743 10.973c0.10494 0.21196-0.034979 0.42391-0.29733 0.42391h-1.9414c-0.31481 0-0.45473-0.097826-0.61214-0.40761l-0.62963-1.288h-4.7572l-0.62963 1.3043c-0.087449 0.19565-0.27984 0.3913-0.62963 0.3913h-1.9239zm4.2325-3.913h2.6584l-1.3292-2.6902h-0.01749l-1.3117 2.6902zm9.2695 3.6033v-10.793c0-0.16304 0.13992-0.30978 0.31481-0.30978h4.2675c3.3755 0 6.1389 2.5598 6.1389 5.6902 0 3.163-2.7634 5.7228-6.1389 5.7228h-4.2675c-0.1749 0-0.31481-0.14674-0.31481-0.30978zm2.7284-2.1033h1.8364c1.9763 0 3.2531-1.4511 3.2531-3.3098 0-1.8424-1.2767-3.2935-3.2531-3.2935h-1.8364v6.6033zm10.774 2.1033v-10.793c0-0.16304 0.13992-0.30978 0.3323-0.30978h4.215c2.3086 0 3.9177 1.6304 3.9177 3.6033 0 2.0217-1.6091 3.6685-3.9002 3.6685h-1.8364v3.8315c0 0.16304-0.15741 0.30978-0.3323 0.30978h-2.0638c-0.19239 0-0.3323-0.14674-0.3323-0.30978zm2.7284-6.212h1.7665c0.75206 0 1.2767-0.55435 1.2767-1.288 0-0.68478-0.52469-1.2065-1.2767-1.2065h-1.7665v2.4946zm6.0165 6.5217c-0.26235 0-0.40226-0.21196-0.29733-0.42391l5.4743-10.973c0.052469-0.097826 0.1749-0.17935 0.29733-0.17935h0.1749c0.12243 0 0.24486 0.081522 0.29733 0.17935l5.4743 10.973c0.10494 0.21196-0.034979 0.42391-0.29733 0.42391h-1.9414c-0.31481 0-0.45473-0.097826-0.61214-0.40761l-0.62963-1.288h-4.7572l-0.62963 1.3043c-0.087449 0.19565-0.27984 0.3913-0.62963 0.3913h-1.9239zm4.2325-3.913h2.6584l-1.3292-2.6902h-0.01749l-1.3117 2.6902zm10.546 3.6033v-5.1848l-3.8652-5.4457c-0.13992-0.21196 0-0.47283 0.27984-0.47283h2.2737c0.13992 0 0.22737 0.081522 0.27984 0.14674l2.4311 3.3424 2.4311-3.3424c0.052469-0.065217 0.12243-0.14674 0.27984-0.14674h2.2737c0.27984 0 0.41975 0.26087 0.27984 0.47283l-3.9177 5.4293v5.2011c0 0.16304-0.15741 0.30978-0.3323 0.30978h-2.0813c-0.19239 0-0.3323-0.14674-0.3323-0.30978z" fill=" #51626f"/><circle cx="93.75" cy="5.75" r="1.75" fill=" #51626f" fill-rule="nonzero"/></g></svg></div>
              <div id="qp-quadpay__learn" class="qp-quadpay__learn">Learn More</div>
            </div>
          </div>
        </div>
        <script async src='#{widget_url}' type='application/javascript'></script>
        <!-- QuadPay Product Page Widget END -->
      HTML

      widget_html.html_safe
    end

    def quadpay_widget_url
      "#{QUADPAY_WIDGET_URL_BASE}/#{Spree::Config.quad_pay_merchant_name}/quadpay-widget-1.0.1.js"
    end

    #####################################################################################
    def self.complete_order_and_payment(payment, order, need_update_personal_info)
      puts "complete payment: " + (payment.id.nil? ? "" : payment.id.to_s)
      puts "payment state: " + payment.state.to_s
      update_order_steps(order,need_update_personal_info)
      puts "payment:" + payment.id.to_s + " response code1:" + (payment.response_code.nil? ? "" : payment.response_code)
      payment.update_qp_order_id
      if payment.state != "completed"
        payment.complete!
      end
      puts "payment:" + payment.id.to_s + " response code2:" + (payment.response_code.nil? ? "" : payment.response_code)

      #@order.next
      # 强制完成
      if order.state != "complete"
        order.completed_at = Time.now.utc.to_s
        order.state = "complete"
        order.save!
      end
      puts "payment:" + payment.id.to_s + " response code3:" + (payment.response_code.nil? ? "" : payment.response_code)
      if order.completed?
        OrderBotWorker.perform_async(order.id)
        true
      else
        false
      end
    end

    def self.update_order_steps(order, need_update_personal_info)
      if need_update_personal_info # 'personal'
        update_order_personal_info(order)
      end

      if !order.has_checkout_step?("address") || order.bill_address.blank? || order.shipping_address.blank?
        update_order_addresses(order)
      end

      order.state = 'payment'
      order.save
    end

    protected
    def self.update_order_personal_info(order)
      user = order.user
      if user.nil?
        build_user(order)
      end

      complete_order_step(order, 'cart')
    end

    # populate shipping/billing with paypal info, in case of 'cart checkout' / 'checkout from page'
    def self.update_order_addresses(order)
      if order.bill_address.blank? && !order.shipping_address.blank?
        order.bill_address = order.shipping_address
        complete_order_step(order, 'address')
      end
    end

    # state machine states have
    def self.complete_order_step(order, order_step)
      original_state = order.state
      order.state = order_step

      if !order.next
        order.state = original_state
        order.save(validate: false) # store data from paypal. user will be redirect to 'personal' tab
      end
    end

    private
    def self.build_user(order)
      if order
        Spree::User.new(
          email: order.email,
          first_name: order.shipping_address.firstname,
          last_name: order.shipping_address.lastname,
          password: order.number,
          password_confirmation: order.number
        )
      else
        Spree::User.new()
      end
    end

  end
end
