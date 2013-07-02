class ApplicationController < ActionController::Base
  protect_from_forgery

  include Spree::Core::ControllerHelpers::Order

  before_filter :check_cart

  def check_cart
    # if can't find order, create it ( true )
    current_order(true) if current_order.blank?
  end
end
