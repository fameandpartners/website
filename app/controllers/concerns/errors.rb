module Concerns
  module Errors
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from ActionController::UnknownController, with: :render_404
      rescue_from ActionController::UnknownAction, with: :render_404
      rescue_from ActiveRecord::RecordInvalid, with: :render_422
      rescue_from Exception, with: :render_500
    end

    protected

    def render_404
      render_error(code: 404)
    end

    def render_422
      render_error(code: 422)
    end

    def render_500
      render_error(code: 500)
    end

    def render_error(code: 404)
      respond_to do |format|
        format.html { render "errors/#{code}", status: code }
        format.xml  { render nothing: true, status: code }
        format.json  { render nothing: true, status: code }
      end
    end

  end
end
