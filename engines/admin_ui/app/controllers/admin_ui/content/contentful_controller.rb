module AdminUi
  module Content
    class ContentfulController < ::AdminUi::ApplicationController

      def index
        @contentful_versions = ContentfulVersion.order.reverse
      end

      def create
        ret_val = Contentful::Version.set_live(current_admin_user, params[:change_message])

        if ret_val
          render status: 200, json: {message: 'Successfully created a new version.'}
        else
          render status: 400, json: {message: 'Failed. Make sure to hit ?developer=preview on the URL to save a new version.'}
        end

      end

      def create_route
        # future: use different params (controller/action)
        route_params = {
          route_name: params[:route_name],
          controller: 'contentful',
          action: 'main'
        }

        ContentfulRoute.create(route_params)

        render status: 200, json: {message: 'Route successfully created!'}
      end

      private

      helper_method :collection

    end
  end
end
