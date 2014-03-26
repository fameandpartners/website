class StaticsController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth

  layout 'statics'

  # enable showing of display banner
  before_filter :display_marketing_banner

  
end
