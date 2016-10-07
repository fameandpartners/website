require 'datagrid'

class BergenProcessGrid
  include Datagrid

  scope do
    Bergen::Operations::ReturnItemProcess
      .includes(
        return_request_item: [
                               :item_return,
                               order_return_request: [:order],
                               line_item:            [
                                                       :order,
                                                       :variant,
                                                       personalization: [
                                                                          :color,
                                                                          :size
                                                                        ]
                                                     ]
                             ]
      )
  end

  # Filters

  # TODO
  # filter(:order_number) do |order_number|
  # end

  # Columns

  column :manage_return, header: '', html: true do |process|
    if (item_return = process.return_request_item.item_return)
      link_to 'manage', admin_ui.item_return_path(item_return), class: 'btn btn-xs btn-info'
    end
  end

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

  column :aasm_state, header: 'Step', order: false do |process|
    process.aasm_state.titleize
  end

  column :failed, header: 'Processed', order: false do |process|
    format(!process.failed) do |processed|
      class_name = processed ? 'check text-success': 'times text-danger'
      content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
    end
  end

  column :created_at do |process|
    format(process.created_at) do |created_at|
      I18n.l(created_at, format: :long)
    end
  end

  # TODO: retry if failed!
  # column :retry, html: true do
  #   RETRY
  # end
end

