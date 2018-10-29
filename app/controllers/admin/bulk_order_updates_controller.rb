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

  rescue CSV::MalformedCSVError => e
    NewRelic::Agent.agent.error_collector.notice_error( e )
    @error = e
  end

  def update
    service = Shipping::BulkTrackingService.new(bulk_update, current_spree_user)

    if params[:admin_bulk_order_update][:find_spree_matches]
      service.detect_spree_matches
    elsif params[:admin_bulk_order_update][:update_make_states]
      service.update_make_states
    elsif params[:admin_bulk_order_update][:setup_shipments]
      service.group_shipments
    elsif params[:admin_bulk_order_update][:mark_valid_shipped]
      service.fire_valid_shipments
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
    @collection = collection.page(params[:page])
  end

  def destroy
    bulk_update

    status = if bulk_update.deletable?
       bulk_update.destroy ? {notice: "Deleted #{bulk_update.filename}"} : { error: "Error deleting #{bulk_update.filename}" }
    else
      {error: "Cannot delete! #{bulk_update.filename} - Has processed items"}
    end

    redirect_to main_app.admin_bulk_order_updates_path, flash: status
  end

  def bulk_update
    @bulk_update ||= model_class.hydrated.order('line_item_updates.row_number').find(params[:id])
  end

  def collection
    @collection ||= model_class.includes(:line_item_updates).order('created_at DESC')
  end


  def model_class
    Admin::BulkOrderUpdate
  end
end
