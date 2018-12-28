module Shipping
  class BulkTrackingImporter

    attr_reader :source_file, :username, :original_filename

    def initialize(source_file:, username:, original_filename:)
      @source_file       = source_file
      @username          = username
      @original_filename = original_filename
    end

    def import
      raw_csv = File.read(source_file)
      u8_csv = raw_csv.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: '')

      csv = CSV.parse(u8_csv,
                     headers:           true,
                     skip_blanks:       true,
                     header_converters: ->(h) { h.to_s.gsub('_', ' ').strip }
      )

      new_bulk_update = Admin::BulkOrderUpdate.new(user: username, filename: original_filename)

      header_mapping = mapped_headers(csv)

      csv.each_with_index do |row, idx|
        attributes = extract_attributes_from_row(row, header_mapping)
        attributes.merge!(row_number: idx + 1)

        new_bulk_update.line_item_updates << Admin::LineItemUpdate.new(attributes)
      end

      new_bulk_update
    end

    private

    def extract_attributes_from_row(row, mapping)
      mapping.each_with_object({}) do |(attr_name, header), attrs|
        attrs[attr_name] = row[header].to_s.strip
      end
    end

    def mapped_headers(csv)
      header_detectors.each_with_object({}) do |(name, detector), mapping|
        next unless header = csv.headers.detect { |h| detector.match(h) }
        mapping[name] = header
      end
    end

    def header_detectors
      {
        order_date:      /order release date/i,
        order_number:    /order no|order number/i,
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

    # headers = ["ORDER RELEASE DATE  下单日期",
    #  "ORDER NO. 订单号",
    #  "STYLE  款号",
    #  "SIZE   尺码 AU/US",
    #  "QUANTITY 数量",
    #  "COLOR 颜色",
    #  "PARCEL SENT DATE  寄件日期",
    #  "TRACKING NO. 运单号",
    #  "客人姓名",
    #  "地址",
    #  "电话"]
    #
  end
end
