class Spree::Admin::StylesController < Spree::Admin::BaseController
  def index
    render locals: {
      styles: Style.get_all
    }
  end

  def update
    style = Style.get_by_name(params[:id])
    style.accessories = params[:accessories]
    style.save

    render nothing: true
  end

  def update_image
    style = Style.get_by_name(params[:id])
    style.image = params[:style][:image]

    if style.save
      render json: {file: serialize_style(style), style: style.name }, status: :created
    else
      render json: {}, status: :error
    end
  end

  private

  def model_class
    ::Style
  end

  def serialize_style(style)
    {
      "name" => style.read_attribute(:image_file_name),
      "size" => style.read_attribute(:image_file_size),
      "style_name" => style.name,
      "thumbnail_url" => style.image.url(:thumbnail),
      "image_url" => style.image.url(:product)
    }
  end
end
