module Returns
  class Importer < ::Importers::FileImporter
    def import
      preface
      create_or_update_records_from_sheet
      associate_item_returns

      info "Done"
    end

    def create_or_update_records_from_sheet
      csv = CSV.read(csv_file, headers: true, skip_blanks: false)
      info "Creating ManuallyManagedReturn Records"

      ManuallyManagedReturn.transaction do
        csv.each_with_index do |row, index|
          # 0 Indexed rows + Header = 2
          row_number = (index + 2).to_s

          row_data = {
            :row_number                 => row_number,
            :rj_ident                   => row['PK for RJMetrics'],
            :column_b                   => row.to_a[1].last, # No Key, direct idx
            :receive_state              => row['Received'],
            :spree_order_number         => row['Spree Order Number'].to_s.squish.strip,
            :return_cancellation_credit => row['RETURN OR CANCELLATION OR STORE CREDIT'],
            :name                       => row['Name'],
            :order_date                 => row['ORDER DATE'],
            :order_month                => row['ORDER MONTH'],
            :return_requested_on        => row['RETURN REQUEST'],
            :comments                   => row['COMMENTS'],
            :product                    => row['PRODUCT'],
            :size                       => row['SIZE'],
            :colour                     => row['COLOUR'],
            :return_category            => row['CATEGORY'],
            :return_sub_category        => row['SUB CATEGORY'],
            :return_office              => row['RETURN OFFICE'],
            :received                   => row['DRESS RECEIVED'],
            :in_inventory               => row['IN INVENTORY'],
            :notes                      => row['NOTES'],
            :restocking                 => row['Restocking?'],
            :returned_to_factory        => row['Returned to Factory'],
            :refund_status              => row['REFUND STATUS'],
            :payment_method             => row['PAYMENT METHOD'],
            :refund_method              => row['REFUND METHOD'],
            :currency                   => row['CURRENCY'],
            :amount_paid                => row['AMOUNT PAID'],
            :spree_amount_paid          => row['Spree Amount Paid'],
            :refund_amount              => row['REFUND AMOUNT'],
            :date_refunded              => row['DATE REFUNDED'],
            :email                      => row['EMAIL'],
            :account_name               => row['ACCOUNT NAME'],
            :account_number             => row['ACCOUNT NUMBER'],
            :account_bsb                => row['ACCOUNT BSB'],
            :account_swift              => row['ACCOUNT SWIFT CODE'],
            :customers_notes            => row['CUSTOMER NOTES'],
            :quantity                   => row['QTY'],
            :deleted_row                => row['Deleted']
          }.map{ |k,v| [k,v.to_s.strip.presence] }.to_h

          info ['create_mmr', row_data[:rj_ident].to_s.ljust(5), row_data[:spree_order_number].to_s.ljust(10) ].join(' ')
          ManuallyManagedReturn.find_or_create_by_row_number(row_number) do |mmr|
            mmr.update_attributes(row_data)
            mmr.save
          end
        end
      end
    end

    def associate_item_returns
      ManuallyManagedReturn.find_each do |mmr|
        begin
          if mmr.deleted_row.present?
            warn "(#{mmr.row_number}) Deleted Row (#{mmr.spree_order_number})"
            mmr.import_status = :deleted_row
            mmr.save
            next
          end

          unless mmr.spree_order
            error "(#{mmr.row_number}) No Order Found (#{mmr.spree_order_number})"
            mmr.import_status = :no_order
            mmr.save
            next
          end

          if mmr.spree_order.line_items.empty?
            error "(#{mmr.row_number}) No Line Items on Order (#{mmr.spree_order_number})"
            mmr.import_status = :no_line_items
            mmr.save
            next
          end

          if mmr.spree_order.line_items.size == 1
            matched_line_item = mmr.spree_order.line_items.first
          else

            unless mmr.product.present?
              error "(#{mmr.row_number}) No PRODUCT Found (#{mmr.spree_order_number})"
              mmr.import_status = :no_product
              mmr.save
              next
            end

            product_matched_items = mmr.spree_order.line_items.select do |sli|
              sli.product.present? && mmr.product.present? && sli.product.name.downcase == mmr.product.downcase
            end

            if product_matched_items.size == 1
              matched_line_item = product_matched_items.first
            else


              # Attempt to detect the items
              order_presenter = ::Orders::OrderPresenter.new(mmr.spree_order)

              items_in_order = order_presenter.line_items.collect do |li|
                {
                  product:      li.style_name.downcase.strip,
                  color:        li.colour_name.downcase.strip,
                  country_size: li.country_size.downcase.strip,
                  raw_size:     li.size.downcase.strip,
                  item:         li.item
                }
              end

              mmr_item          = {
                product:      mmr.product.to_s.downcase.strip,
                color:        mmr.colour.to_s.downcase.strip,
                country_size: mmr.size.to_s.downcase.strip,
                raw_size:     mmr.size.to_s.downcase.gsub(/us|au/, '').strip
              }


              similar_items     = items_in_order.map do |li|
                similarity        = (li.to_a & mmr_item.to_a).size
                product_weighting = (mmr_item[:product] == li[:product]) ? 1 : 0
                [li, similarity + product_weighting]
              end
              most_similar_item = similar_items.max_by(&:last).first[:item]

              matched_line_item = most_similar_item

              # binding.pry unless matched_line_item.present?

              # binding.pry unless Date.parse(mmr.return_requested_on) < Date.parse('2014.07.01')
              #
              # # Date.parse(mmr.return_requested_on) < Date.parse('2014.07.01')
              #
              # warn "Couldnt find matching returnable for Order #{mmr.spree_order_number}}"
              # next
            end
          end

          if matched_line_item.present?
            item_return = matched_line_item.item_return || ItemReturnEvent.creation.create(line_item_id: matched_line_item.id).item_return

            existing_event = item_return.events.legacy_data_import.first

            info "(#{mmr.row_number}) Creating Event for row: #{mmr.row_number}"

            calculated_attributes = {}
            calculated_attributes[:refund_amount_in_cents] = Money.parse(
                          mmr.refund_amount.to_s.gsub('$','').tr(',','').gsub(/[a-z]+/i,'').strip,
                          matched_line_item.order.currency.to_s).fractional

            potential_state = mmr.receive_state.to_s.downcase.strip.tr(' ','_').to_sym
            potential_comment_state = mmr.comments.to_s.downcase.strip.tr(' ','_').to_sym
            calculated_attributes[:acceptance_status]      = if ItemReturn::STATES.include?(potential_state)
              potential_state
            elsif ItemReturn::STATES.include?(potential_comment_state)
              potential_comment_state
            elsif /app?rr?o[cv]ed/i.match(mmr.comments)
              :approved
            else
              :unknown
            end

            calculated_attributes[:requested_at]           = Chronic.parse(mmr.return_requested_on).try(:to_date).try(:iso8601)
            calculated_attributes[:refunded_at]            = Chronic.parse(mmr.date_refunded).try(:to_date).try(:iso8601)
            calculated_attributes[:product_style_number]   = matched_line_item.product.sku
            calculated_attributes[:product_customisations] = !!matched_line_item.personalization.present?
            calculated_attributes[:order_paid_currency]    = matched_line_item.order.currency.to_s
            calculated_attributes[:order_paid_amount]      = Money.parse(matched_line_item.order.total.to_s).fractional


            calculated_attributes[:line_item_id]      = matched_line_item.id
            calculated_attributes[:email]     = matched_line_item.order.email
            if (completed_payment = matched_line_item.order.payments.completed.last)
              payment = ::Reports::Payments::PaymentReportPresenter.from_payment(completed_payment)
              attributes_to_merge = {
                payment_method: payment.payment_type,
                order_payment_date:   payment.payment_date,
                order_paid_amount:    payment.amount_in_cents,
                order_paid_currency:  payment.currency,
                order_payment_ref:    payment.transaction_id
              }.compact

              calculated_attributes.merge!(attributes_to_merge)
            end

            whitelisted_attributes = mmr.attributes.symbolize_keys.slice(*ItemReturnEvent::LEGACY_DATA_IMPORT_ATTRIBUTES)

            event = item_return.events.legacy_data_import.create!(whitelisted_attributes.merge(calculated_attributes))

            mmr.item_return       = item_return
            mmr.item_return_event = event

            if existing_event.present?
              if existing_event.row_number.to_s == mmr.row_number.to_s
                mmr.import_status = :event_stored
              else
                warn "(#{mmr.row_number}) #{mmr.row_number} Event Exists"
                mmr.import_status = :multiple_events
              end
            else
              mmr.import_status = :event_stored
            end

            mmr.save

          else
            warn "(#{mmr.row_number}) No Matched Returnable for Order #{mmr.spree_order_number}}"
          end
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
        end
      end
    end
  end
end
