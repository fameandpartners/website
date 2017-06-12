module Concerns
  module Errors
    extend ActiveSupport::Concern

    MYSTERIOUS_ROUTES = [ 'undefined', '/au/undefined', '1000668' ].freeze

    included do
      rescue_from ActiveRecord::RecordInvalid,         with: -> { render_error(code: 422) }
      rescue_from ActiveRecord::RecordNotFound,        with: -> { render_error(code: 404) }
      rescue_from ActionController::UnknownController, with: -> { render_error(code: 404) }
      rescue_from ActionController::RoutingError,      with: -> { render_error(code: 404) }
      rescue_from AbstractController::ActionNotFound,  with: -> { render_error(code: 404) }
    end

    def non_matching_request
      path   = params.fetch(:path, '')
      format = params.fetch(:format, '')

      if path.match(/\.php$/) || format.eql?('php')
        head :not_acceptable, layout: false

      elsif MYSTERIOUS_ROUTES.any? { |v| v.match(Regexp.escape(path)) }
        data = request.env.select {|key,_| key.upcase == key }
        NewRelic::Agent.record_custom_event('UndefinedURL', data)
        render text: 'Not Found', status: :not_found

      elsif ContentfulRoute.where(route_name: request.path)[0].present?
        c = ContentfulController.new
        c.main(params, request.path, &:render)

      else
        # NOTE: Alexey Bobyrev 14 Jan 2017
        # Raise error here to make it visible for application#rescue_from
        # Ref: https://github.com/rails/rails/issues/671
        raise ActionController::RoutingError.new(path)
      end
    end

    # NOTE: Alexey Bobyrev 30 Mar 2017
    # Redefine 404s method render for all controllers
    # Rquired due to legacy spree methods
    # Ref: https://github.com/fameandpartners/website/blob/master/vendor/cache/spree-7d19c8933042/core/app/controllers/spree/taxons_controller.rb#L3
    def render_404
      render_error(code: 404)
    end

    protected

    def render_error(code:)
      if Rails.application.config.consider_all_requests_local
        raise
      else
        respond_to do |format|
          format.html { render "errors/#{code}", status: code, layout: 'redesign/application' }
          format.all  { render nothing: true, status: code }
        end
      end
    end

  end
end
