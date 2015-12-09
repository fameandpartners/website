class LandingPagesController < ApplicationController
  layout 'redesign/application'

  # enable showing of display banner
  before_filter :display_marketing_banner

  # Added 2015-12-10
  def bridal_dresses
    # TODO - Add Real Copy
    title('Bridal Dresses', 'Beautiful Bridal Gowns Online', default_seo_title)
    description("Discover beautiful bridal dresses at Fame & Partners")
  end
end
