module Revolution
  class BannersController < ApplicationController

    def delete
      @banner = Revolution::Banner.find(params[:banner_id])
      @banner.destroy
      flash[:success] = "Banner deleted"
      redirect_to admin_ui.edit_content_page_path(@banner.translation.page)
    end

  end
end

