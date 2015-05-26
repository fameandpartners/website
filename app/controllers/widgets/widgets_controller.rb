class Widgets::WidgetsController < ActionController::Base
  include Concerns::SiteVersion
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
end
