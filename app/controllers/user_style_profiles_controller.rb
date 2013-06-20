class UserStyleProfilesController < ApplicationController
  def show
    @style_profile = StyleReport.find_by_spree_user_id!(params[:user_id])

    render :layout => 'statics'
  end
end
