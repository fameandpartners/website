class Spree::Admin::Celebrity::MoodboardItemsController < Spree::Admin::BaseController
  before_filter :load_data

  def index
    @moodboard_items = @celebrity.moodboard_items
  end

  def new
    @moodboard_item = @celebrity.moodboard_items.new 
  end

  def create
    @moodboard_item = @celebrity.moodboard_items.new(params[:celebrity_moodboard_item])
    if @moodboard_item.save
      flash[:success] = 'Moodboard item has been successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit
    @moodboard_item = @celebrity.moodboard_items.find(params[:id])
  end

  def update
    @moodboard_item = @celebrity.moodboard_items.find(params[:id])
    if @moodboard_item.update_attributes(params[:celebrity_moodboard_item])
      flash[:success] = 'Moodboard item has been successfully updated.'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def update_positions
    params[:positions].each do |id, index|
      model_class.update_all({ position: index }, {id: id})
    end
    render nothing: true
  end

  def destroy
    @moodboard_item = @celebrity.moodboard_items.find(params[:id])
    @moodboard_item.try(:destroy)
  end

  private

  def load_data
    @celebrity = Celebrity.find(params[:celebrity_id])
  end

  def model_class
    Celebrity::MoodboardItem
  end
end
