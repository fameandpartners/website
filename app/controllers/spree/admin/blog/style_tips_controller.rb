class Spree::Admin::Blog::StyleTipsController < Spree::Admin::BaseController
  def index
    @style_tips = StyleTip.all
  end

  def new
    @style_tip = StyleTip.new
  end

  def create
    @style_tip = StyleTip.create! params[:style_tip]
    if @style_tip.errors.any?
      render :new
    else
      redirect_to :index
    end
  end

  def edit
    @style_tip = StyleTip.find params[:id]
  end

  def update
    style_tip = StyleTip.find params[:id]
    if style_tip.update_attributes!(params[:style_tip])
      redirect_to :index
    else
      render action: :edit
    end
  end
end
