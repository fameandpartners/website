module Shipping
  class BulkTrackingImporter

    attr_reader :source_file, :username, :original_filename

    def initialize(source_file:, username:, original_filename:)
      @source_file       = source_file
      @username          = username
      @original_filename = original_filename
    end


    def import
      csv = CSV.read(source_file,
                     headers:           true,
                     skip_blanks:       true,
                     header_converters: ->(h) { h.to_s.gsub('_', ' ').strip }
      )

      new_bulk_update = Admin::BulkOrderUpdate.new(user: username, filename: original_filename)

      # headers = ["ORDER RELEASE DATE  下单日期",
      #  "ORDER NO. 订单号",
      #  "STYLE  款号",
      #  "SIZE   尺码                                                      AU/US",
      #  "QUANTITY 数量",
      #  "COLOR 颜色",
      #  "PARCEL SENT DATE  寄件日期",
      #  "TRACKING NO. 运单号",
      #  "客人姓名",
      #  "地址",
      #  "电话"]
      #
      mapped_headers = {}
      header_detectors.map do |name, detector|
        next unless header = csv.headers.detect { |h| h[detector] }
        mapped_headers[name] = header
      end

      csv.each_with_index do |row, idx|
        attributes = mapped_headers.each_with_object({}) { |(name, header), attrs|
          attrs[name] = row[header].to_s.strip
        }

        attributes.merge!(row_number: idx + 1)

        new_bulk_update.line_item_updates << Admin::LineItemUpdate.new(attributes)
      end

      new_bulk_update
    end

    def header_detectors
      {
        order_date:      /order release date/i,
        order_number:    /order no/i,
        style_name:      /style/i,
        size:            /size/i,
        quantity:        /quantity/i,
        colour:          /colour|color/i,
        dispatch_date:   /parcel sent date|shipment date/i,
        tracking_number: /tracking/i,
        make_state:      /make stat/i,
        raw_line_item:   /line item/i,
      }
    end
  end
end
