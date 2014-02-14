class Spree::Admin::StylesController < Spree::Admin::BaseController
  def index
  end

  def show
    render action: index
  end

  def update
    params[:styles].each do |style_name, style_title|
      Style.update_all({ title: style_title }, {name: style_name})
    end

    render nothing: true
  end

  private

  def model_class
    ::Style
  end
end
