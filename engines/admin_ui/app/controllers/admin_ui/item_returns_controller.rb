module AdminUi
  class ItemReturnsController < AdminUi::ApplicationController

    LINE_ITEM_OBJECT_DICT = {}

    def index
      @collection = ItemReturnsGrid.new(params[:item_returns_grid])

      if params[:item_returns_grid]
        order_number = params[:item_returns_grid][:order_number]
        order_ = Spree:: Order.where(:number => order_number).first
        if order_.present?
          @number_order_ = order_number
        else
          @number_order_ = ''
        end
      end

      @weekly_refund = (params[:scope] == :refund_queue)

      respond_to do |f|
        f.html do
          @collection.scope do |scope|
            scope = scope.send(params[:scope]) if params[:scope]
            scope.page(params[:page]).per(20)
          end
        end
        f.csv do
          send_data @collection.to_csv,
                    type: "text/csv",
                    disposition: 'inline',
                    filename: "item_returns-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def show
      @item_return = ItemReturn.find(params[:id])
      @page_title = "Return - #{@item_return.order_number} - #{@item_return.line_item_id} - #{@item_return.contact_email}"
    end

    # Only handles Manual Order Return Requests Right now.
    def new
      @new_return_form = Forms::ItemReturns::ManualOrderReturn.new(ItemReturnEvent.manual_order_return.build)
      current_order_number = params[:order_number] || @new_return_form.order_number
      if current_order_number.present?
        get_line_item_record(current_order_number)
        @new_return_form.order_number = current_order_number
      end

    end

    def create
      @new_return_form = Forms::ItemReturns::ManualOrderReturn.new(ItemReturnEvent.manual_order_return.build)
      @new_return_form.user = current_admin_user
      @new_return_form.user = current_admin_user
      if @new_return_form.validate(params[:forms_item_returns_manual_order_return]) && @new_return_form.save
        redirect_to item_return_path(@new_return_form.model.item_return), notice: 'Return Created!'
      else
        get_line_item_record(@new_return_form.order_number)
        render :new
      end
    end

    def enable_autorefund
      @item_return = ItemReturn.find(params[:item_return_id])
      order = @item_return.line_item.order
      order.autorefundable = true
      order.save!
      redirect_to item_return_path(@item_return)
    end

    def disable_autorefund
      @item_return = ItemReturn.find(params[:item_return_id])
      order = @item_return.line_item.order
      order.autorefundable = false
      order.save!
      redirect_to item_return_path(@item_return)
    end

    def generate_new_return_label
      item_return = ItemReturn.find(params[:item_return_id])
      order = Spree::Order.find_by_number(item_return.order_number)
      label = ReturnsProcessesControllerHelper.create_label(order.number)
      redirect_to label.nil? ? item_return_path(item_return) : label.label_pdf_url
    end

    def bulk_refund_process
      BulkRefundWorker.perform_async(current_admin_user.email)

      redirect_to :back, notice: "Bulk refund process started"
    end

    def get_line_item_record(order_number)
      if order_number.present?
        order_ = Spree:: Order.where(:number => order_number).first
        if order_.present?
          order_id = order_.id
          user_id = order_.user_id
          if user_id.present?
            current_user_obj = Spree:: User.where(:id => user_id).first
            customer_email_value = current_user_obj.email
            customer_name = (current_user_obj.first_name).to_s + (current_user_obj.last_name).to_s
          end
          customer_name ||= (order_.user_first_name).to_s + (order_.user_last_name).to_s
          @line_item_ = Spree:: LineItem.where(:order_id => order_id)
          LINE_ITEM_OBJECT_DICT.clear
          ReturnRequestItem::LINE_ITEM_SELECT_MAP.clear
          for item_ in @line_item_
            item_dict_ = {}
            ReturnRequestItem::LINE_ITEM_SELECT_MAP[item_.id] = item_.id
            variant_obj = Spree:: Variant.where(:id => item_.variant_id).first
            product_id_ = variant_obj.product.id
            product_obj = Spree:: Product.where(:id => product_id_)
            product_style_number = variant_obj.sku
            product_style_number ||= product_obj.name
            line_item_obj_ = Spree:: LineItem.where(:id => item_.id).first

            item_dict_["quantity"] = line_item_obj_.quantity
            item_dict_["customer_name"] = verify_value_present(customer_name)
            customer_email_value ||= order_.email
            item_dict_["customer_email"] = verify_value_present(customer_email_value)
            product_name_value = item_.curation_name
            item_dict_["product_name"] = verify_value_present(product_name_value)
            item_dict_["product_style_number"] = verify_value_present(product_style_number)

            name = "name" + (item_.id).to_s
            LINE_ITEM_OBJECT_DICT[name] = item_dict_
          end
        end
      end
    end

    def verify_value_present(param)
      if param.present?  # object.nil?||object.empty?  or not blank?
        param
      else
        ""
      end
    end

    private

    helper_method def possible_events
      ::AdminUi::ItemReturns::EventsController.event_forms.keys
    end
  end
end
