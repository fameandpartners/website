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
            flash[:success] = "Page updated"
            redirect_to action: :edit
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
        begin
          params[:page][:variables] = eval(params[:page][:variables])
          @page = Revolution::Page.new(params[:page])
          if @page.save
            redirect_to action: :index
          else
            render action: :new
        end
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          flash[:error] = "An error occured, please check the variable definition"
          render action: :new
        end
      end

      def show
      end

      def destroy
        @page = Revolution::Page.find(params[:id])
        if @page.translation.present?
          @page.translations.destroy_all
        end
        @page.delete
        flash[:success] = "Page deleted"
        redirect_to action: :index
      end

      private

      helper_method :collection, :page

      def collection
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i
        if params.has_key?(:search) && params[:search].present?
          @collection ||= Revolution::Page.where("LOWER(path) like '%#{params[:search].downcase}%'").order('path ASC').page(page).per(per_page)
        else
          @collection ||= Revolution::Page.order('path ASC').page(page).per(per_page)
        end
      end

      def page
        @page ||= Revolution::Page.find(params[:id])
      end

    end
  end
end
