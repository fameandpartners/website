module Admin
  class NumbersController < ActionController::Base

    respond_to :json

    # GET
    def index
      line_item_number = params[:number]
      status_code = 200
      line_item_dict = AdminUi::ItemReturnsController::LINE_ITEM_OBJECT_DICT
      current_option_name = "name" + line_item_number.to_s
      return_line_item_dict = line_item_dict[current_option_name]
      render json: return_line_item_dict, status: status_code
    end

  end
end
