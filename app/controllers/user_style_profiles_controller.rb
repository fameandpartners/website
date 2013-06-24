class UserStyleProfilesController < ApplicationController
  def show
    @style_profile = UserStyleProfile.find_by_user_id!(params[:user_id])

    render :layout => 'statics'
  end

  def debug
    @style_profile = UserStyleProfile.find_by_user_id!(params[:user_id])

    render :layout => 'statics'
  end
end
