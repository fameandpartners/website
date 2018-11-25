module AdminUi
  module Content
    class PagesController < ::AdminUi::ApplicationController
      before_filter :normalize_page_variables, only: [:update, :create]

      def index
      end

      def new
        @page = Revolution::Page.new
      end

      def edit
      end

      def update
        if page.update_attributes(params[:page])
          flash[:success] = 'Page updated'
          redirect_to action: :edit
        else
          flash[:error] = 'An error occured, please check errors below'
          render action: :edit
        end
      end

      def create
        @page = Revolution::Page.new(params[:page])
        if @page.save
          flash[:notice] = 'Page successfully created'
          redirect_to edit_content_page_path(@page)
        else
          flash[:error] = 'An error occured, please check errors below'
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
        flash[:success] = 'Page deleted'
        redirect_to action: :index
      end

      private

      helper_method :collection, :page, :products

      def normalize_page_variables
        variables_params = params[:page][:variables] || []

        params[:page][:variables] = variables_params.inject({}) do |hash, kv_hash|
          hash.merge(kv_hash['key'] => kv_hash['value'])
        end
      end

      def collection
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i
        if query = params[:search]
          @collection ||= Revolution::Page.for_path(query).paging(page, per_page)
        else
          @collection ||= Revolution::Page.paging(page, per_page)
        end
      end

      def page
        @page ||= Revolution::Page.find(params[:id])
      end
    end
  end
end
