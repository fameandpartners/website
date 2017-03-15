Spree::Admin::Orders::CustomerDetailsController.class_eval do
  def update
    new_user_id = params[:order].delete(:user_id)

    if @order.update_attributes(params[:order])
      if @order.available_shipping_methods(:back_end).present?
        if new_user_id
          ::Admin::ChangeOrderOwner.new(
            site_version: current_site_version,
            new_owner_id: new_user_id,
            order:        @order
          ).process
        end

        while @order.next;
        end

        flash[:success] = t('customer_details_updated')

        if @order.shipment
          redirect_to edit_admin_order_shipment_path(@order, @order.shipment)
        else
          redirect_to new_admin_order_shipment_path(@order)
        end

      else
        flash[:error] = t('errors.messages.no_shipping_methods_available')
        redirect_to admin_order_customer_path(@order)
      end

    else
      render :action => :edit
    end
  end
end
