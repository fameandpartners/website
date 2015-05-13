class Admin::BulkOrderUpdatesController < Spree::Admin::BaseController

  helper_method :collection, :bulk_update

  def create
    import_file = params[:bulk_order_update_file]

    csv = CSV.read(import_file.tempfile,
                   headers: true,
                   skip_blanks: true,
                   header_converters: ->(h){ h.strip }
    )

    new_bulk_update = Admin::BulkOrderUpdate.create(user: current_spree_user.email, filename:  import_file.original_filename )


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
    header_detectors = {
      :order_date      => /order release date/i,
      :order_number    => /order no/i,
      :style_name      => /style/i,
      :size            => /size/i,
      :quantity        => /quantity/i,
      :colour          => /colour|color/i,
      :dispatch_date   => /parcel sent date/i,
      :tracking_number => /tracking/i
    }

    mapped_headers = {}
    header_detectors.map do |name, detector|
      next unless header = csv.headers.detect { |h| h[detector] }
      mapped_headers[name] = header
    end

    csv.each_with_index do |row, idx|
      attributes = mapped_headers.each_with_object({}) { |(name, header), attrs|
        attrs[name] = row[header]
      }

      attributes.merge!(row_number: idx + 1)

      new_bulk_update.line_item_updates << Admin::LineItemUpdate.new(attributes)
    end

    new_bulk_update.save

    redirect_to main_app.admin_bulk_order_update_path(new_bulk_update)
  end

  def update
    service = BulkTrackingService.new(bulk_update)

    if params[:admin_bulk_order_update][:find_spree_matches]
      service.find_spree_matches
    elsif params[:admin_bulk_order_update][:setup_shipments]
      service.group_shipments
    elsif params[:admin_bulk_order_update][:mark_valid_shipped]
      service.fire_valid_shipments(current_spree_user)
    end

    redirect_to main_app.admin_bulk_order_update_path(bulk_update)
  end

  def new
  end

  def show
    bulk_update
  rescue ActiveRecord::RecordNotFound
    redirect_to main_app.admin_bulk_order_updates_path, notice: 'Not Found'
  end

  def index


  end

  def bulk_update
    @bulk_update ||= model_class.includes(
      line_item_updates:
        {
          order: [],
          shipment: [],
          line_item: [:variant, :fabrication]
        }
    ).order('line_item_updates.row_number').find(params[:id])
  end

  def collection
    @collection ||= model_class.order('created_at DESC')
  end


  def model_class
    Admin::BulkOrderUpdate
  end
end
