class Spree::Admin::Celebrity::ProductAccessoriesController < Spree::Admin::BaseController
  before_filter :load_data

  def index
    @products    = @celebrity.products
    @accessories = @celebrity.accessories
  end

  def new
    @accessory = @celebrity.accessories.new(spree_product_id: params[:product_id])
  end

  def create
    @accessory = @celebrity.accessories.new(params[:celebrity_product_accessory])
    if @accessory.save
      flash[:success] = 'Celebrity product accessory has been successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit
    @accessory = @celebrity.accessories.find(params[:id])
  end


  def update
    @accessory = @celebrity.accessories.find(params[:id])
    if @accessory.update_attributes(params[:celebrity_product_accessory])
      flash[:success] = 'Celebrity product accessory has been successfully updated.'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def update_positions
    params[:positions].each do |id, index|
      @celebrity.accessories.update_all({ position: index }, {id: id})
    end
    render nothing: true
  end

  def destroy
    @accessory = @celebrity.accessories.find(params[:id])
    if @accessory
      @accessory.try(:destroy)
    end
  end

  private

  def load_data
    @celebrity = Celebrity.find(params[:celebrity_id])
  end

  def model_class
    Celebrity::ProductAccessory
  end
end
