class Admin::BulkOrderUpdatesController < Spree::Admin::BaseController

  helper_method :collection, :bulk_update

  def create
    import_file = params[:bulk_order_update_file]

    new_bulk_update = Shipping::BulkTrackingImporter.new(
      source_file:       import_file.tempfile,
      original_filename: import_file.original_filename,
      username:          current_spree_user.email
    ).import

    new_bulk_update.save

    redirect_to main_app.admin_bulk_order_update_path(new_bulk_update)
  end

  def update
    service = Shipping::BulkTrackingService.new(bulk_update)

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
    @bulk_update ||= model_class.hydrated.order('line_item_updates.row_number').find(params[:id])
  end

  def collection
    @collection ||= model_class.order('created_at DESC')
  end


  def model_class
    Admin::BulkOrderUpdate
  end
end
