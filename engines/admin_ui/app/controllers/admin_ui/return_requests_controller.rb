require_dependency "admin_ui/application_controller"

module AdminUi
  class ReturnRequestsController < ApplicationController
    def index
    end

    def show


    end

    private
    helper_method :collection, :return_request

    def return_request
      @return_request ||= OrderReturnRequest.find(params[:id])
    end

    def collection
      page =1
      per_page = 50
      @collection ||= ::OrderReturnRequest.includes(:order).page(page).per(per_page)
    end
  end
end
