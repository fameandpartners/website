class Spree::Admin::Blog::PromTipsController < Spree::Admin::BaseController
  def index
    @prom_tips = PromTip.all
  end

  def new
    @prom_tip = PromTip.new
  end

  def create
    @prom_tip = PromTip.create! params[:prom_tip]
    if @prom_tip.errors.any?
      render :new
    else
      redirect_to :index
    end
  end

  def edit
    @prom_tip = PromTip.find params[:id]
  end

  def update
    prom_tip = PromTip.find params[:id]
    if prom_tip.update_attributes!(params[:prom_tip])
      redirect_to :index
    else
      render action: :edit
    end
  end

  def destroy
    post = FashionNews.find(params[:id])
    post.destroy if post.user == spree_current_user && spree_current_user.admin?
  end
end
