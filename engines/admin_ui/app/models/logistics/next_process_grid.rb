require 'datagrid'

module Logistics
  class NextProcessGrid
    include Datagrid

    self.default_column_options = { order: false }

    class GridProcess
      extend Forwardable

      attr_reader :process
      def_delegators :process,
                     :aasm_state,
                     :failed,
                     :id,
                     :record_number,
                     :created_at

      def initialize(return_request_process)
        @process = return_request_process
      end

      def order_number
        process.order_return_request.order.number
      end

      def item_returns
        process.order_return_request
          .return_request_items
          .map(&:item_return)
          .compact
      end

      def global_skus
        item_returns
          .map(&:line_item)
          .map { |li| Orders::LineItemPresenter.new(li, li.order) }
          .map { |presenter| GlobalSku.find_or_create_by_line_item(line_item_presenter: presenter) }
      end
    end

    scope do
      NextLogistics::ReturnRequestProcess
        .includes(order_return_request: [
          :order,
          return_request_items: [
            item_return:          [:line_item],
            order_return_request: [:order],
              line_item: [
                :order,
                :variant,
                personalization: [:color, :size]
              ]
            ]
        ])
        .order('next_logistics_return_request_processes.created_at DESC')
    end

    decorate do
      GridProcess
    end

    # Filters

    filter(:id)
    puts(:id)
    filter(:order_number) do |order_number|
      self.where('spree_orders.number = ?', order_number)
    end

    filter(:step, :enum, select: NextLogistics::ReturnRequestProcess.aasm.states_for_select) do |step|
      self.where('next_logistics_return_request_processes.aasm_state = ?', step)
    end
    filter(:processed, :xboolean) do |processed|
      self.where('next_logistics_return_request_processes.failed = ?', !processed)
    end
    filter(:created_at, :datetime, range: true)

    # Columns

    # DataGrid caveat: HTML columns don't use the defined decorator
    column :manage_return, header: '', html: true do |process|
      grid_process = GridProcess.new(process)
      puts("123-------------------------------------------------------------")
      grid_process.item_returns.map do |item_return|
        link_to "manage #{item_return.id}", admin_ui.item_return_path(item_return), class: 'btn btn-xs btn-info'
      end.join(content_tag(:br)).html_safe
    end

    column :id

    column :order_number do |grid_process|
      grid_process.order_number
    end

    column :upcs, header: 'UPCs' do |grid_process|
      grid_process.global_skus.map(&:upc).join(', ')
    end

    column :aasm_state, header: 'Step' do |grid_process|
      grid_process.aasm_state.titleize
    end

    column :failed, header: 'Processed' do |grid_process|
      format(!grid_process.failed) do |processed|
        class_name = processed ? 'check text-success' : 'times text-danger'
        content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
      end
    end

    column :created_at, order: true do |grid_process|
      format(grid_process.created_at) do |created_at|
        I18n.l(created_at, format: :long)
      end
    end

    column :retry, html: true do |process|
      if process.failed
        link_to 'Retry', admin_ui.retry_logistics_next_path(process), class: 'btn btn-xs btn-success', data: { confirm: t('next_logistics.retry_message') }
      end
    end
  end
end
