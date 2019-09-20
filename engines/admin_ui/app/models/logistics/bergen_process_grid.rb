require 'datagrid'

module Logistics
  class BergenProcessGrid
    include Datagrid

    self.default_column_options = { order: false }

    scope do
      Bergen::Operations::ReturnItemProcess
        .includes(return_request_item: [
          :item_return,
          order_return_request: [:order],
          line_item: [
            :order,
            :variant,
            personalization: [:color, :size]
          ]
        ])
        .order('bergen_return_item_processes.created_at DESC')
    end

    # Filters

    filter(:id)
    filter(:order_number) do |order_number|
      self.where('spree_orders.number = ?', order_number)
    end
    filter(:asn) do |asn|
      self.where('item_returns.bergen_asn_number = ?', asn)
    end
    # TODO: UPC is not a relationship, but a concept! How to implement this?
    # filter(:upc) do |upc|
    # end
    filter(:step, :enum, select: Bergen::Operations::ReturnItemProcess.aasm.states_for_select) do |step|
      self.where('bergen_return_item_processes.aasm_state = ?', step)
    end
    filter(:processed, :xboolean) do |processed|
      self.where('bergen_return_item_processes.failed = ?', !processed)
    end
    filter(:created_at, :datetime, range: true)

    # Columns

    column :manage_return, header: '', html: true do |process|
      if (item_return = process.return_request_item.item_return)
        puts('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
        link_to 'manage', admin_ui.item_return_path(item_return), class: 'btn btn-xs btn-info'
      end
    end

    column :id

    column :order_number do |process|
      process.return_request_item.order.number
    end

    column :asn, header: 'ASN' do |process|
      if (item_return = process.return_request_item.item_return)
        item_return.bergen_asn_number
      end
    end

    column :upc, header: 'UPC' do |process|
      line_item           = process.return_request_item.line_item
      line_item_presenter = Orders::LineItemPresenter.new(line_item, line_item.order)
      global_sku          = GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
      global_sku.upc
    end

    column :aasm_state, header: 'Step' do |process|
      process.aasm_state.titleize
    end

    column :failed, header: 'Processed' do |process|
      format(!process.failed) do |processed|
        class_name = processed ? 'check text-success' : 'times text-danger'
        content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
      end
    end

    column :created_at, order: true do |process|
      format(process.created_at) do |created_at|
        I18n.l(created_at, format: :long)
      end
    end

    column :retry, html: true do |process|
      if process.failed
        link_to 'Retry', admin_ui.retry_logistics_bergen_path(process), class: 'btn btn-xs btn-success', data: { confirm: t('bergen.retry_message') }
      end
    end
  end
end
