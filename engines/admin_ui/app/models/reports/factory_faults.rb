module Reports
  class FactoryFaults
    include RawSqlCsvReport

    def initialize(from:, to:)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)

      @from = from.to_datetime.beginning_of_day
      @to   = to.to_datetime.end_of_day
    end

    def from
      @from.to_s
    end

    def to
      @to.to_s
    end

    def description
      'FactoryFaultReturns'
    end

    def to_sql
      <<-SQL
        SELECT
          acceptance_status AS "Status",
          order_number AS "Spree Order Number",
          requested_action AS "Return/Exchange",
          customer_name AS "Customer's Name",
          to_char(order_payment_date, 'dd/mm/yyyy') AS "Order Date",
          to_char(requested_at, 'dd/mm/yyyy') AS "Return Request Date",
          to_char(received_on, 'dd/mm/yyyy') AS "Return Received Date",
          product_name AS "Product",
          product_style_number AS "SKU Number",
          product_size AS "Size",
          product_colour AS "Colour",
          reason_category AS "Return Reason",
          split_part(split_part(data, '@', 1), 'user:', 2) AS "QC'd By",
          reason_sub_category AS "Comments",
          factory_fault_reason AS "Factory Fault Reason"
        FROM item_returns LEFT JOIN item_return_events
          ON item_returns.uuid = item_return_events.item_return_uuid
          AND event_type = 'receive_item'
        WHERE
          requested_at IS NOT NULL
        AND requested_at between '#{from}' and '#{to}'
        AND factory_fault
        ORDER BY requested_at DESC
      SQL
    end

  end
end
