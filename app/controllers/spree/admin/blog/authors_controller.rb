class Spree::Admin::Blog::AuthorsController < Spree::Admin::BaseController

  def index
    @authors = Blog::Author.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def new
    @blog_author = Blog::Author.new
  end

  def edit
    @blog_author = Blog::Author.find(params[:id])
  end

  def create
    attrs = params['blog_author']
    @blog_author = Blog::Author.new(attrs)
    @blog_author.user = current_spree_user

    if @blog_author.slug.blank? && @blog_author.fullname.present?
      @blog_author.slug = slug_from_name(@blog_author.fullname)
    end

    if @blog_author.valid?
      @blog_author.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    attrs = params['blog_author']
    @blog_author = Blog::Author.find(params[:id])
    if @blog_author.update_attributes(attrs)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @blog_author = Blog::Author.find(params[:id])
    @blog_author.destroy
    redirect_to action: :index
  end

  private

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def model_class
    Blog::Author
  end
end
