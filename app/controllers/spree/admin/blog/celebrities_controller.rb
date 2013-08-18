class Spree::Admin::Blog::CelebritiesController < Spree::Admin::Blog::BaseController

  def index
    @celebrities = Blog::Celebrity.page(params[:page]).
                   per(params[:per_page] || Spree::Config[:orders_per_page]).
                   order('blog_celebrities.last_name ASC')
  end

  def new
    @blog_celebrity = Blog::Celebrity.new
  end

  def edit
    @blog_celebrity = Blog::Celebrity.find(params[:id])
  end

  def create
    attrs = params['blog_celebrity']
    @blog_celebrity = Blog::Celebrity.new(attrs)
    @blog_celebrity.user = current_spree_user
    update_featured_at(@blog_celebrity, attrs['featured'])

    if @blog_celebrity.slug.blank?
      @blog_celebrity.slug = slug_from_name(@blog_celebrity.fullname)
    end

    if @blog_celebrity.valid?
      @blog_celebrity.save

      Blog::CelebrityPhoto.where(user_id: current_spree_user.id, celebrity_id: nil).update_all({celebrity_id: @blog_celebrity.id})
      @blog_celebrity.reload.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    attrs = params['blog_celebrity']
    @blog_celebrity = Blog::Celebrity.find(params[:id])
    @blog_celebrity.assign_attributes(attrs)
    update_featured_at(@blog_celebrity, attrs['featured'])
    if @blog_celebrity.valid?
      @blog_celebrity.save
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def destroy
    @blog_celebrity = Blog::Celebrity.find(params[:id])
    @blog_celebrity.destroy
    redirect_to action: :index
  end

  def toggle_featured
    celebrity = Blog::Celebrity.find(params[:id])
    if celebrity.featured?
      celebrity.featured_at = nil
    else
      celebrity.featured_at = Time.now.utc
    end
    celebrity.save
    respond_to do |format|
      format.js {render text: 'ok' }
    end
  end

  private

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def update_featured_at(celebrity, featured)
    if featured == '1' && celebrity.featured_at.blank?
      celebrity.featured_at = Time.now.utc
    elsif featured == '0'
      celebrity.featured_at = nil
    end
  end

  def model_class
    Blog::Celebrity
  end
end
