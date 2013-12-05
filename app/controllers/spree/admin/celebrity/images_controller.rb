class Spree::Admin::Celebrity::ImagesController < Spree::Admin::ResourceController
  before_filter :load_data

  create.before :set_celebrity
  update.before :set_celebrity
  destroy.before :destroy_before

  private

  def location_after_save
    admin_celebrity_images_url(@celebrity)
  end

  def load_data
    @celebrity = Celebrity.find(params[:celebrity_id])
  end

  def set_celebrity
    @image.celebrity = @celebrity
  end

  def destroy_before
    @celebrity = @image.celebrity
  end

  private

  def model_class
    Celebrity::Image
  end
end
