class Spree::Admin::Blog::ConfigurationsController < Spree::Admin::Blog::BaseController
  #skip_before_filter :authorize_admin

  def show
    @config = Blog.config
  end

  def update
    config = Blog.config
    params[:config].each do |key, value|
      Blog::Preference.update_preference(key, value) if @config.send(key) != value
    end

    render nothing: true
  end

  private

  def model_class
    Blog::Preference
  end
end
