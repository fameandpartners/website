class ApplicationController < ActionController::Base
  protect_from_forgery

  include Spree::Core::ControllerHelpers::Order
end
