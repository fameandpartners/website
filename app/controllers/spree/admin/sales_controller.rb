class Spree::Admin::SalesController < Spree::Admin::BaseController
  def edit
    @sale = Spree::Sale.first || Spree::Sale.new
  end

  def update
    @sale = Spree::Sale.first || Spree::Sale.new
    if @sale.update_attributes(params[:sale])
      redirect_to edit_admin_sale_path
    else
      render :edit
    end
  end

  def set_free_customisations
    Spree::Config.set_preference(:free_customisations, params[:free_customisations])
    
    render nothing: true
  end

  private

  def model_class
    Spree::Sale
  end
end
