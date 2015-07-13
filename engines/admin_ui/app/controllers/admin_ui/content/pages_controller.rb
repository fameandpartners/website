module AdminUi
  module Content
    class PagesController < AdminUi::ApplicationController

      def index
      end

      def edit
      end

      def update
        if page.update_attributes(params[:page])
          redirect_to action: :index
        else
          render action: :edit
        end
      end

      def new
      end

      def show
      end

      private

      helper_method :collection, :page

      def collection
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i
        @collection ||= Revolution::Page.order('path ASC').page(page).per(per_page)
      end

      def page
        @page ||= Revolution::Page.find(params[:id])
      end

    end
  end
end
