namespace :item_return do
  task :recalculate => :environment do
    ItemReturn.all.each do |item_return| 
      ItemReturnCalculator.new(item_return).run.save!
    end
  end

  desc 'migrate from return_requests'
  task :import_from_requests => :environment do
    ReturnRequestItem.find_each do |rri|
      puts rri.id

      next if rri.action == "keep"

      item_return = ItemReturn.where(item_id: rri.line_item.id).first.presence || ItemReturnEvent.creation.create.item_return

      attrs = {
        order_number:           rri.order.number,
        item_id:                rri.line_item.id,
        qty:                    rri.quantity,
        requested_action:       rri.action,
        requested_at:           rri.created_at,
        customer_name:          rri.order.full_name,
        reason_category:        rri.reason_category,
        reason_sub_category:    rri.reason,
        request_notes:          '',
        contact_email:          rri.order.email,
        product_name:           rri.line_item.product.name,
        product_style_number:   rri.line_item.product.sku,
        product_colour:         rri.line_item_presenter.colour_name,
        product_size:           rri.line_item_presenter.country_size,
        product_customisations: rri.line_item_presenter.personalizations?,
        acceptance_status:      :requested,
      }

      # TODO PICK THE SUCCESSFUL ONE
      if rri.order.payments.last
        payment = ::PaymentsReport::PaymentReportPresenter.from_payment(rri.order.payments.last)
        attrs.merge!(
          order_payment_method: payment.payment_type,
          order_paid_amount:    payment.amount_in_cents,
          order_paid_currency:  payment.currency,
          order_payment_ref:    payment.token
        )
      end

      item_return.events.return_requested.create(attrs)
    end
  end
end

