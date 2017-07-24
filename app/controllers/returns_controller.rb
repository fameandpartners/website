class ReturnsController < ApplicationController
  layout 'returns/application'
  def main
    render 'layouts/returns/main'
  end
  def guest
    render 'layouts/returns/guest'
  end

end