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

      elsif MYSTERIOUS_ROUTES.any? { |v| v.match(path) }
        data = request.env.select {|key,_| key.upcase == key }
        NewRelic::Agent.record_custom_event('UndefinedURL', data)
        render text: 'Not Found', status: :not_found

      else
        # NOTE: Alexey Bobyrev 14 Jan 2017
        # Raise error here to make it visible for application#rescue_from
        # Ref: https://github.com/rails/rails/issues/671
        raise ActionController::RoutingError.new(path)
      end
    end

    protected

    def render_error(code:)
      if Rails.application.config.consider_all_requests_local
        raise
      else
        respond_to do |format|
          format.html { render "errors/#{code}", status: code }
          format.all  { render nothing: true, status: code }
        end
      end
    end

  end
end
