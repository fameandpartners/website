# coding: utf-8
require 'csv'

module Orders
  class LineItemCsvGenerator
    attr_reader :orders, :query_params

    def initialize(orders, query_params = {})
      @orders = orders
      @lis = orders.flat_map(&:line_items)
      @query_params = query_params

      if query_params[:show_only_completed]
        @show_only_completed = true
      end

      if query_params[:refulfill_only]
        @refulfill_only = true
      end

      if query_params[:batch_only]
        @batch_only = true
      end

      if query_params[:ready_batches]
        @ready_batches = true
      end

      if query_params[:making_only]
        @making_only = true
      end
    end

    def filename
      parts = ['fp_orders']
      if @show_only_completed || @making_only
        parts << Date.parse(query_params[:created_at_gt]).strftime('from_%Y-%m-%d') if query_params[:created_at_gt].present?
        parts << Date.parse(query_params[:created_at_lt]).strftime('to_%Y-%m-%d')   if query_params[:created_at_lt].present?
        parts << (query_params.fetch(:completed_at_not_null) { false } == '1' ? 'only_complete' : 'all_states')
      end
      if @refulfill_only
        parts << 'refulfill_only'
      end
      if @batch_only
        parts << 'batch_only'
      end
      if @ready_batches
        parts << 'ready_batches'
      end
      if @making_only
        parts << 'items_ready_for_production'
      end

      parts << 'generated_at'
      parts << DateTime.now.to_s(:file_timestamp)
      parts.join('_') << '.csv'
    end

    def headers
      en_headers.collect { |k| "#{k} #{cn_headers[k]}" }
    end

    # https://app.asana.com/0/423269087196963/550425321843318
    # Spree Admin > Return Insurance data in exported csv file always has an
    # AUD currency even if the item was purchased in USD
    #
    # When given a line item as a Orders::LineItemCSVPresenter object,
    # when the line item is a "RETURN_INSURANCE"
    # this method returns the "correct" currency, which is the orders currency
    # One of these days we have to repair the database corruption going on where
    # all return ins. line items have a currency of "AUD"
    def corrected_currency(line)
      if line.return_insurance?
        line.order.currency
      else
        line.currency
      end
    rescue
      "USD"
    end

    def to_csv
      CSV.generate(headers: true) do |csv|
        if @batch_only
          bcs_sorted = BatchCollection.all.sort {|x, y| y.line_items.count <=> x.line_items.count}

          csv << (bcs_sorted.map {|bc| "#{bc.batch_key}: #{bc.line_items.count}"})
          csv << []
        end

        csv << headers
        @lis.each do |line|

          lip = Orders::LineItemPresenter.new(line, line.order)

          if (@refulfill_only || @batch_only || @ready_batches || @making_only)
            # ignore certain products
            if line.ignore_line?
              next
            end

            # dont' show canceled orders
            if line.order.state == 'canceled'
              next
            end
            # dont' show anything that has shipped or canceled
            if line.order&.shipment&.shipped_at.present? || line.order&.shipment&.tracking.present? || line.order.state == 'canceled'
              next
            end
          end

          #filter out any items that have shipping info
          if (@refulfill_only || @ready_batches || @batch_only || @making_only) && line.line_item_update
            next
          end

          # filter for refulfill items that have no shipping info
          if @refulfill_only && line.refulfill_status.nil?
            next
          end

          # filter out non batched
          if @batch_only && (line.batch_collections.empty? || line.batch_collections&.first&.status == 'closed')
            next
          end

          # filter out non ready batches
          if @ready_batches && (line.batch_collections.empty? || line.batch_collections&.first&.status == 'open')
            next
          end

          if @making_only
            # filter out refulfill and batched items
            if !@refulfill_only && !line.refulfill_status.nil?
              next
            end
            if !@batch_only && !line.batch_collections.empty?
              next
            end
          end

          csv << [
            line.order.state,
            line.order.number,
            # lip.sample_sale?,
            line.refulfill_status,
            line.id,
            line.order.legit_line_items.count,
            line.order.completed_at&.to_date,
            line.making_options.map(&:product_making_option).compact.map(&:making_option ).map(&:code).join("|"),
            line&.ship_by_date&.to_date,
            line.shipment&.tracking,
            line.shipment&.shipped_at&.to_date,
            line.fabrication&.state,
            line.new_sku,
            line.product_sku_with_fabric_code,
            line.product.name,
            line.factory,
            line.color&.presentation,
            lip&.fabric_material,
            line.size&.presentation,
            line.personalization&.height,
            line.personalization&.customization_values&.map { |c| c['customisation_value']['presentation']}&.join("|"),
            line.order.promotions.map(&:name).join("|"),
            line.order.email,
            line.order.customer_notes,
            line.order.ship_address.name,
            line.order.ship_address.phone,
            line.order.ship_address.to_s,
            line.return_item,
            line.return_item&.action,
            line.return_item&.reason_category,
            line.price,
            corrected_currency(line),
            resolve_refulfill_upc(line, lip),
            line.image_url,
            line.production_sheet_url
          ]
        end
      end
    end

  private
    # we do this cause upcs are screwed from back in the da day
    def resolve_refulfill_upc(line, lip)
      if line.return_inventory_item
        return "#{line.return_inventory_item.vendor}: #{line.return_inventory_item.upc}"
      else
        return lip.global_sku&.upc
      end
    end

    def en_headers
      [
        :order_state,
        :order_number,
        # :sample_sale_item,
        :refulfill,
        :line_item,
        :total_items,
        :completed_at,
        :making,
        :ship_by_date,
        :tracking_number,
        :shipment_date,
        :fabrication_state,
        :sku,
        :style,
        :style_name,
        :factory,
        :color,
        :fabric,
        :size,
        :height,
        :customisations,
        :promo_codes,
        :email,
        :customer_notes,
        :customer_name,
        :customer_phone_number,
        :shipping_address,
        :return_request,
        :return_action,
        :return_details,
        :price,
        :currency,
        :upc,
        :image,
        :prouction_sheet
      ]
    end

    def cn_headers
      {
        order_number:            '(订单号码)',
        completed_at:            '(订单日期)',
        express_making:          '(快速决策)',
        ship_by_date:            '(要求出厂日期)',
        tracking_number:         '(速递单号)',
        style:                   '(款号)',
        factory:                 '(工厂)',
        color:                   '(颜色)',
        fabric:                  '(面料)',
        size:                    '(尺寸)',
        customisations:          '(特殊要求)',
        customer_name:           '(客人名字)',
        customer_phone_number:   '(客人电话)',
        shipping_address:        '(客人地址)'
      }
    end

  end
end
