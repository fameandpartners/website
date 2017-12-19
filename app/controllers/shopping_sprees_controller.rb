class ShoppingSpreesController < ApplicationController

  def join
    cookies[:shopping_spree_starting_state] = 'onboarding'
    cookies[:shopping_spree_id] = params[:shopping_spree_id]
    redirect_to '/'
  end
  
end
