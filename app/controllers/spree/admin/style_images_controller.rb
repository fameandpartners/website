class Spree::Admin::StyleImagesController < Spree::Admin::BaseController
  def update
    service = StyleImageUpdaterService.new(params[:style_image])

    if service.update
      render json: service.resource, status: :created
    else
      render json: {}, status: :error
    end
  end

  def destroy
    style = Style.get_by_name(params[:style_name])
    style_image = style.images.where(position: params[:position]).first

    style_image.destroy if style_image.present?

    render locals: {
      style_name: params[:style_name],
      position:   params[:position],
      default_image: StyleImage.new.image.url
    }
  end

  private

  def model_class
    ::StyleImage
  end

  class StyleImageUpdaterService
    def initialize(params)
      @params = params
    end

    def update
      style_image.image = @params[:image]
      style_image.save
    end

    def resource
      {
        style: style.name,
        position: style_image.position,
        file: {
          "name" => style_image.read_attribute(:image_file_name),
          "size" => style_image.read_attribute(:image_file_size),
          "style_name" => style.name,
          "thumbnail_url" => style_image.image.url(:thumbnail),
          "image_url" => style_image.image.url(:product)
        }
      }
    end

    private

    def style
      @style ||= Style.get_by_name(@params[:style_id])
    end

    def style_image
      @style_image ||= style.images.where(position: @params[:position]).first_or_initialize
    end
  end
end
