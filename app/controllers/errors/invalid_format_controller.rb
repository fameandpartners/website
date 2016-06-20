module Errors
  class InvalidFormatController < ActionController::Base
    layout false

    def capture_php
      head :not_acceptable
    end
  end
end
