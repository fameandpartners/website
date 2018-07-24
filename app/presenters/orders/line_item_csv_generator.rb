require 'csv'

module Orders
  class LineItemCsvGenerator
    attr_reader :orders, :query_params

    def initialize(orders, query_params = {})
      @orders = orders
      @lis = orders.map {|ord| Spree::LineItem.find_by_id(ord.attributes["line_item_id"].to_i)}
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

    def to_csv
      line = Orders::LineItemCSVPresenter

      CSV.generate(headers: true) do |csv|
        if @batch_only
          bcs_sorted = BatchCollection.all.sort {|x, y| y.line_items.count <=> x.line_items.count}

          csv << (bcs_sorted.map {|bc| "#{bc.batch_key}: #{bc.line_items.count}"})
          csv << []
        end

        csv << headers
        @lis.each_with_index do |li, index|
          line.set_line @orders[index].attributes

          lip = nil
          if li
            lip = Orders::LineItemPresenter.new(li)
          end

          if (@refulfill_only || @batch_only || @ready_batches || @making_only)
            # ignore certain products
            if line.ignore_line?
              next
            end

            # dont' show canceled orders
            if li.order.state == 'canceled'
              next
            end
            # dont' show anything that has shipped or canceled
            if li.order&.shipment&.shipped_at.present? || li.order&.shipment&.tracking.present? || li.order.state == 'canceled'
              next
            end
          end

          #filter out any items that have shipping info
          if (@refulfill_only || @ready_batches || @batch_only || @making_only) && li.line_item_update
            next
          end

          # filter for refulfill items that have no shipping info
          if @refulfill_only && li.refulfill_status.nil?
            next
          end

          # filter out non batched
          if @batch_only && (li.batch_collections.empty? || li.batch_collections&.first&.status == 'closed')
            next
          end

          # filter out non ready batches
          if @ready_batches && (li.batch_collections.empty? || li.batch_collections&.first&.status == 'open')
            next
          end

          if @making_only
            # filter out refulfill and batched items
            if !@refulfill_only && !li.refulfill_status.nil?
              next
            end
            if !@batch_only && !li.batch_collections.empty?
              next
            end
          end

          csv << [
            line.order_state,
            line.order_number,
            # lip.sample_sale?,
            li&.refulfill_status,
            line.line_item_id,
            line.total_items,
            line.completed_at_date,
            line.fast_making,
            lip&.projected_delivery_date&.to_date,
            # line.delivery_date,
            line.tracking_number,
            line.shipment_date,
            line.fabrication_state,
            line.style,
            line.style_name,
            line.factory,
            line.color,
            lip&.fabric_material,
            line.adjusted_size,
            line.height,
            line.customization_values,
            line.custom_color,
            line.promo_codes,
            line.email,
            line.customer_notes,
            line.customer_name,
            line.customer_phone_number,
            line.shipping_address,
            line.return_request,
            line.return_action,
            line.return_details,
            line.price,
            line.currency,
            resolve_refulfill_upc(li, line)
          ]
        end
      end
    end

  private
    # we do this cause upcs are screwed from back in the da day
    def resolve_refulfill_upc(li, line)
      if @refulfill_only
        return "#{li.return_inventory_item.vendor}: #{li.return_inventory_item.upc}"
      else
        return line.product_number
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
        :express_making,
        :ship_by_date,
        :tracking_number,
        :shipment_date,
        :fabrication_state,
        :style,
        :style_name,
        :factory,
        :color,
        :fabric,
        :size,
        :height,
        :customisations,
        :custom_color,
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
        :upc
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
