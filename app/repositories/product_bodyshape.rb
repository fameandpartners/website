module Repositories; end
class Repositories::ProductBodyshape
  class << self
    def read_all
      ProductStyleProfile::BODY_SHAPES
    end

    # find by name or return nil
    def get_by_name(name)
      result = Array.wrap(name).compact.map do |n|
        n = n.to_s.downcase
        read_all.find{|shape| shape.downcase == n}
      end
      result.size < 2 ? result.first : result
    end
  end
end
