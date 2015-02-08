module Repositories; end
class Repositories::ProductBodyshape
  class << self
    def read_all
      ProductStyleProfile::BODY_SHAPES
    end

    # find by name or return nil
    def get_by_name(name)
      return nil if name.blank?
      name = name.to_s.downcase
      read_all.find{|shape| shape.downcase == name}
    end
  end
end
