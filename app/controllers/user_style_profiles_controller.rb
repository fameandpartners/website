class UserStyleProfilesController < ApplicationController
  layout 'statics'

  def show
    @style_profile = UserStyleProfile.find_by_user_id!(params[:user_id])
  end

  def debug
    @style_profile = UserStyleProfile.find_by_user_id!(params[:user_id])
  end

  def recomendations
    user = Spree::User.find(params[:user_id])
    @products = Spree::Product.recommended_for(user)
  end
end
