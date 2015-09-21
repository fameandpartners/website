module AdminUi
  module Content
    class PagesController < ::AdminUi::ApplicationController

      def index
      end

      def edit
      end

      def update
        begin
          params[:page][:variables] = eval(params[:page][:variables])
          if page.update_attributes(params[:page])
            redirect_to action: :index
          else
            render action: :edit
          end
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          flash[:error] = "An error occured, please check the variable definition"
          render action: :edit
        end
      end

      def new
        @page = Revolution::Page.new
      end

      def create
        @page = Revolution::Page.new(params[:page])
        if @page.save
          redirect_to action: :index
        else
          render action: :new
        end
      end

      def show
      end

      def destroy
        @page = Revolution::Page.find(params[:id])
        if @page.translation.present?
          @page.translation.delete
        end
        @page.delete
        redirect_to action: :index
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
