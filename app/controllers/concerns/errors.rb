module Concerns
  module Errors
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordInvalid,         with: -> { render_error(code: 422) }
      rescue_from ActiveRecord::RecordNotFound,        with: -> { render_error(code: 404) }
      rescue_from ActionController::UnknownController, with: -> { render_error(code: 404) }
      rescue_from ActionController::UnknownAction,     with: -> { render_error(code: 404) }
      rescue_from ActionController::RoutingError,      with: -> { render_error(code: 404) }
    end

    # NOTE: Alexey Bobyrev 14 Jan 2017
    # Raise error here to make it visible for application#rescue_from
    # Ref: https://github.com/rails/rails/issues/671
    def raise_routing_error
      raise ActionController::RoutingError.new(params[:path])
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
