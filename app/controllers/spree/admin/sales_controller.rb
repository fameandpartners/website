class Spree::Admin::SalesController < Spree::Admin::ResourceController
  def update
    invoke_callbacks(:update, :before)
    if @object.update_attributes(params[object_name])

      invoke_callbacks(:update, :after)
      flash[:success] = flash_message_for(@object, :successfully_updated)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
      end
    else
      invoke_callbacks(:update, :fails)
      respond_with(@object)
    end
  end
end
