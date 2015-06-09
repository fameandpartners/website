class Widgets::SiteNavigationsController < Widgets::WidgetsController
  # widget for main nav of the site
  # used in iframe
  def main_nav
    # default renderer
    render :main_nav, layout: false
  end
end
