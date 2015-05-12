module UserCart; end
class UserCart::CartProductPresenter < OpenStruct
  def serialize
    result = self.marshal_dump.clone

    result[:price] = price.marshal_dump
    result[:image] = image.marshal_dump if image.present?
    result[:size] = size.marshal_dump if size.present?
    result[:color] = color.marshal_dump if color.present?

    result[:customizations] = (customizations || []).map{|t| { id: t.id, name: t.name, display_price: t.display_price.to_s }}
    result[:making_options] = (making_options || []).map{|option|
      { name: option.name, display_price: option.display_price.to_s }
    }

    result
  end
end
