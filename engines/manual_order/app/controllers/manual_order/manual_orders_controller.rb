module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'admin_ui'

    helper_method :manual_order_form, :manual_order_filter

    def index
      @collection = ManualOrdersGrid.new(params[:manual_orders_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]) }
        end
        f.csv do
          send_data @collection.to_csv,
                    type: "text/csv",
                    disposition: 'inline',
                    filename: "manual_orders-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def new

    end

    def create
     if manual_order_form.validate(params[:forms_manual_order])
       order = manual_order_form.save { |hash| manual_order_form.save_order(hash) }

       OrderBotWorker.perform_async(order.id)

       flash[:success] = "Order " \
                          "#{view_context.link_to order.number, spree.admin_order_path(order.number)} " \
                          "has been created successfully".html_safe
       redirect_to manual_orders_path
     end
    end

    def sizes_options
      render json: manual_order_filter.size_options
    end

    def fabric_options
      render json: manual_order_filter.fabric_options
    end

    def colors_options
      if  manual_order_filter.fabric_options.empty?
        render json: manual_order_filter.color_options
      else
        render json: []
      end

    end

    def heights_options
      render json: manual_order_filter.heights_options
    end

    def customisations_options
      render json: manual_order_filter.customisations_options
    end

    def images
      render json: manual_order_filter.images
    end

    def price
      render json: manual_order_filter.price
    end

    def autocomplete_customers
      render json: manual_order_filter.users_searched
    end

    def user_data
      render json: manual_order_filter.user_data
    end

    private

    def manual_order_form
      @manual_order_form ||= Forms::ManualOrderForm.new(Spree::Order.new)
    end

    def manual_order_filter
      @manual_order_filter ||= Forms::ManualOrderFilter.new(params)
    end

  end
end
