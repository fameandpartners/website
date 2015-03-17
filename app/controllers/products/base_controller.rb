class Products::BaseController < ApplicationController
  rescue_from Errors::ProductInactive, with: :redirect_to_default_collection
  rescue_from Errors::ProductNotFound, with: :redirect_to_default_collection

  def redirect_to_default_collection
    redirect_to dresses_path, notice: "Sorry, we can't found this dress"
  end
end
