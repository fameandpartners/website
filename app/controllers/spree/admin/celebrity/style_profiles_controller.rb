class Spree::Admin::Celebrity::StyleProfilesController < Spree::Admin::BaseController
  def edit
    @celebrity = Celebrity.find(params[:celebrity_id])
    @style_profile = @celebrity.style_profile || @celebrity.build_style_profile
  end

  def update
    @celebrity = Celebrity.find(params[:celebrity_id])
    @style_profile = @celebrity.style_profile || @celebrity.build_style_profile

    if @style_profile.update_attributes(params[:style_profile])
      redirect_to edit_admin_celebrity_style_profile_path(@celebrity)
    else
      render :edit
    end
  end

  private

  def model_class
    Celebrity::StyleProfile
  end
end
