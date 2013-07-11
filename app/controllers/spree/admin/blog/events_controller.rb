class Spree::Admin::Blog::EventsController < Spree::Admin::Blog::BaseController

  def index
    @events = Blog::Event.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def new
    @blog_event = Blog::Event.new
  end

  def edit
    @blog_event = Blog::Event.find(params[:id])
  end

  def create
    attrs = params['blog_event']
    @blog_event = Blog::Event.new(attrs)
    @blog_event.user = current_spree_user
    if @blog_event.slug.blank? && @blog_event.name.present?
      @blog_event.slug = slug_from_name(@blog_event.name)
    end
    if @blog_event.valid?
      @blog_event.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def update
    attrs = params['blog_event']
    @blog_event = Blog::Event.find(params[:id])
    if @blog_event.update_attributes(attrs)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @blog_event = Blog::Event.find(params[:id])
    @blog_event.destroy
    redirect_to action: :index
  end

  private

  def model_class
    Blog::Event
  end
end
