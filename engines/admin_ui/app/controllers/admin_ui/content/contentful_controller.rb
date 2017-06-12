module AdminUi
  module Content
    class ContentfulController < ::AdminUi::ApplicationController

      def index
        @contentful_versions = ContentfulVersion.order.reverse
      end

      def create
        ret_val = Contentful::Version.set_live(current_admin_user, params[:change_message])

        if ret_val
          render status: 200, json: {message: 'Successfully created new version'}
        else
          render status: 400, json: {message: 'Failed. Make sure to hit ?developer=preview on the URL to save a new version'}
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
