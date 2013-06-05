class Spree::Admin::Blog::FashionNewsController < Spree::Admin::BaseController
  def index
    @fashion_news = FashionNews.all
  end

  def new
    @fashion_news = FashionNews.new
  end

  def create
    @fashion_news = FashionNews.create! params[:fashion_news]
    if @fashion_news.errors.any?
      render :new
    else
      redirect_to :index
    end
  end

  def edit
    @fashion_news = FashionNews.find params[:id]
  end

  def update
    fashion_news = FashionNews.find params[:id]
    if fashion_news.update_attributes!(params[:fashion_news])
      redirect_to :index
    else
      render action: :edit
    end
  end
end
