class Spree::Admin::StylesController < Spree::Admin::BaseController
  def index
    render locals: {
      styles: Style.get_all
    }
  end

  def update
    style = Style.get_by_name(params[:style_image])
    style.update_attributes(params[:style])

    render nothing: true
  end

  private

  def model_class
    ::Style
  end
end
