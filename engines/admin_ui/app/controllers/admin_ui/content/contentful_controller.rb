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
          route_name: params[:route_name].downcase,
          controller: 'contentful',
          action: 'main'
        }
        cr = ContentfulRoute.new(route_params)

        if cr.save
          Contentful::Version.clear_version_cache
          render status: 200, json: {message: 'Route successfully created!'}
        else
          render status: 400, json: {message: cr.errors.map{|attr_name, message| message }}
        end

      end

      private

      helper_method :collection

    end
  end
end
