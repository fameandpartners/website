class Spree::Admin::CelebritiesController < Spree::Admin::BaseController

  def new
    @celebrity = Celebrity.new
  end

  def create
    @celebrity = Celebrity.new(params[:celebrity])

    if @celebrity.save
      redirect_to edit_admin_celebrity_path(@celebrity)
    else
      render :new
    end
  end

  def index
    @celebrities = Celebrity.all
  end

  def edit
    @celebrity = Celebrity.find(params[:id])
  end

  def update
    @celebrity = Celebrity.find(params[:id])

    if @celebrity.update_attributes(params[:celebrity])
      redirect_to edit_admin_celebrity_path(@celebrity)
    else
      render :edit
    end
  end

  def destroy
    @celebrity = Celebrity.find(params[:id])
    @celebrity.destroy
    redirect_to admin_  scelebrities_path
  end

  private

  def model_class
    Celebrity
  end
end
