class Widgets::WidgetsController < ActionController::Base
  #include Concerns::SiteVersion
  #include Spree::Core::ControllerHelpers::Order
  #include Spree::Core::ControllerHelpers::Auth

  layout 'redesign/application'
  include Spree::AuthenticationHelpers
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include ApplicationHelper
  include PathBuildersHelper
  include Concerns::SiteVersion
  include Concerns::UserCampaignable
  include Concerns::AutomaticDiscount
  include Marketing::Gtm::Controller::Container
  include Preferences
end
