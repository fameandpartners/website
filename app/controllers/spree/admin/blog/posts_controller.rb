class Spree::Admin::Blog::PostsController < Spree::Admin::BaseController

  def index
    @posts = Blog::Post.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
  end

  def new
    prepare_form_relations
    @blog_post = Blog::Post.new
  end

  def edit
    prepare_form_relations
    @blog_post = Blog::Post.find(params[:id])
  end

  def create
    attrs = params['blog_post']
    @blog_post = Blog::Post.new(attrs)
    @blog_post.user = current_spree_user
    @blog_post.slug = slug_from_name(@blog_post.title.to_s) if @blog_post.slug.blank?
    update_published_at(@blog_post, attrs['publish'])

    if @blog_post.valid?
      @blog_post.save
      redirect_to action: :index
    else
      prepare_form_relations
      render action: :new
    end
  end

  def update
    attrs = params['blog_post']
    @blog_post = Blog::Post.find(params[:id])
    @blog_post.assign_attributes(attrs)
    update_published_at(@blog_post, attrs['publish'])

    if @blog_post.valid?
      @blog_post.save
      redirect_to action: :index
    else
      prepare_form_relations
      render action: :edit
    end
  end

  def destroy
    @blog_post = Blog::Post.find(params[:id])
    @blog_post.destroy
    redirect_to action: :index
  end

  private

  def model_class
    Blog::Post
  end

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def prepare_form_relations
    @authors = Blog::Author.all
    @categories = Blog::Category.all
  end

  def update_published_at(post, publish)
    if publish == '1' && post.published_at.blank?
      post.published_at = Time.now.utc
    elsif publish == '0'
      post.published_at = nil
    end
  end

end
