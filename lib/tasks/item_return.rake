namespace :item_return do
  task :recalculate => :environment do
    ItemReturn.all.each do |item_return| 
      ItemReturnCalculator.new(item_return).run.save!
    end
  end

  desc 'migrate from return_requests'
  task :import_from_requests => :environment do
    ReturnRequestItem.find_each do |rri|

      next if rri.action == "keep"



      attrs = {
        order_number:           rri.order.number,
        item_id:                rri.line_item.id,
        qty:                    rri.quantity,
        requested_action:       rri.action,
        reason_category:        rri.reason_category,
        reason_sub_category:    rri.reason,
        request_notes:          '',
        contact_email:          rri.order.email,
        product_name:           rri.line_item.product.name,
        product_style_number:   rri.line_item.product.sku,
        product_colour:         rri.line_item_presenter.colour_name,
        product_size:           rri.line_item_presenter.country_size,
        product_customisations: rri.line_item_presenter.personalizations?,
      }

      if rri.order.payments.last
        payment = ::PaymentsReport::PaymentReportPresenter.from_payment(rri.order.payments.last)
        attrs.merge!(
          order_payment_method: payment.payment_type,
          order_paid_amount:    payment.amount_in_cents,
          order_payment_ref:    payment.token
        )
      end





# binding.pry
      ItemReturnEvent.return_requested.create(attrs)

      # break
    end
  end
end

