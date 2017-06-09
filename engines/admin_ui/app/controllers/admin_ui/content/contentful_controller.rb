module AdminUi
  module Content
    class ContentfulController < ::AdminUi::ApplicationController      

      def index
        @contentful_versions = ContentfulVersion.order(id: :desc).page(params[:page])
      end

      def show
      end

      def create
        ret_val = Contentful::Version.set_live(current_admin_user, params[:change_message])

        respond_to do |format|
          format.html do
            if ret_val
              flash[:success] = "New contently version is live."
            else
              flash[:error] = "Something did not work right."
            end
          end
        end
      end


      private

      helper_method :collection

      def collection
        # TODO: @dagnar, help me figure out how to paginate this
        # Potentially using https://github.com/mislav/will_paginate
        # ContentfulVersion.all
        # page = (params[:page] || 1).to_i
        # per_page = (params[:per_page] || 50).to_i
        # @collection ||= ContentfulVersion.all
      end
    end
  end
end
