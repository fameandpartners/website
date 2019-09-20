module AdminUi
  module Backend
    class ReturnRequestsController < AdminUi::ApplicationController
      def index
      end

      def show
      end

      private
      helper_method :collection, :return_request, :wrap_line_item

      def return_request
        a = params[:id]
        @return_request ||= OrderReturnRequest.includes(:order => [:line_items]).find(params[:id])
      end

      def collection
        page        = (params[:page] || 1).to_i
        per_page    = (params[:per_page] || 50).to_i
        @collection ||= ::OrderReturnRequest.includes(:order).order('created_at DESC').page(page).per(per_page)
      end

      def wrap_line_item(item)
        Orders::LineItemPresenter.new(item, Orders::OrderPresenter.new(item.order))
      end
    end
  end
end
