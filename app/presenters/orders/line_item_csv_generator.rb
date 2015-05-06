require 'csv'

module Orders
  class LineItemCsvGenerator
    attr_reader :orders, :query_params

    def initialize(orders, query_params = {})

      orders.includes(:line_items => {:personalizations => [], :variants => { :product => [] }} )
      @orders = orders.collect { |o| OrderPresenter.new(o) }
      @query_params = query_params
    end

    def filename
      parts = ['fp_orders']
      parts << Date.parse(query_params[:created_at_gt]).strftime('from_%Y-%m-%d') if query_params[:created_at_gt].present?
      parts << Date.parse(query_params[:created_at_lt]).strftime('to_%Y-%m-%d')   if query_params[:created_at_lt].present?
      parts << (query_params.fetch(:completed_at_not_null) { false } == '1' ? 'only_complete' : 'all_states')
      parts << 'generated_at'
      parts << DateTime.now.to_s(:file_timestamp)
      parts.join('_') << '.csv'
    end

    def to_csv
      CSV.generate(headers: true) do |csv|
        headers_added = false

        orders.map do |order|
          order.line_items.map do |line_item|

            csv << line_item.headers unless headers_added
            headers_added = true

            begin
              csv << line_item.as_report.values
            rescue NoMethodError => e
              binding.pry if Rails.env.development?
              next
            end
          end
        end
      end
    end
  end
end
