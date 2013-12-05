class Spree::Admin::Celebrity::ProductsController < Spree::Admin::BaseController
  def edit
    @celebrity = Celebrity.find(params[:celebrity_id])
    @products = Spree::Product.not_deleted
  end

  def update
    @celebrity = Celebrity.find(params[:celebrity_id])

    if @celebrity.update_attributes(params[:celebrity])
      redirect_to edit_admin_celebrity_products_path(@celebrity)
    else
      render :edit
    end
  end

  private

  def model_class
    Celebrity
  end
end
