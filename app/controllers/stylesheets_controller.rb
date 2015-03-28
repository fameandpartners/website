class StylesheetsController < ActionController::Base
  caches_page :product_colors, gzip: false

  respond_to :css

  layout false

  def product_colors
  end
end
