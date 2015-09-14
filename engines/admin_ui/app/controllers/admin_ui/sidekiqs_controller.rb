module AdminUi
  class SidekiqsController < AdminUi::ApplicationController

    layout 'admin_ui_nav_only'
    def show
      # NOOP
      # We render the sidekiq views into an iframe
    end
  end
end
