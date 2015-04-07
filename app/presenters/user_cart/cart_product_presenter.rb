module UserCart; end
class UserCart::CartProductPresenter < FastOpenStruct
  def serialize
    result = self.marshal_dump.clone

    result[:price] = price.marshal_dump
    result[:image] = image.marshal_dump if image.present?
    result[:size] = size.marshal_dump if size.present?
    result[:color] = color.marshal_dump if color.present?
    if customizations.present?
      result[:customizations] = customizations.map{|t| t.as_json(root: false) }
    end

    result
  end
end
