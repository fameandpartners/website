require 'datagrid'

module AdminUi
  class Render3dImagesController < AdminUi::ApplicationController

    def index
      @collection = Render3dImagesGrid.new(params[:render3d_images_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(300) }
        end
        f.csv do
          send_data @collection.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "render3d-images-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def show
      @render3d_image = Render3d::Image.find(params[:id])
      @page_title = "Render3d::Image - #{@render3d_image.product_id} - #{@render3d_image.color_id} - #{@item_return.customisation_id}"
    end

    def new
      @new_return_form = Forms::ItemReturns::ManualOrderReturn.new(ItemReturnEvent.manual_order_return.build)
    end

    def create
      @new_return_form = Forms::ItemReturns::ManualOrderReturn.new(ItemReturnEvent.manual_order_return.build)
      @new_return_form.user = current_admin_user
      if @new_return_form.validate(params[:forms_item_returns_manual_order_return]) && @new_return_form.save
        redirect_to item_return_path(@new_return_form.model.item_return), notice: 'Return Created!'
      else
        render :new
      end
    end

  end
end
