module Repositories; end
class Repositories::ProductBodyshape
  class << self
    def read_all
      ProductStyleProfile::BODY_SHAPES
    end

    # find by name or return nil
    def get_by_name(name)
      if name.is_a? Array
        result = []
        name.each do |n|
          next if n.nil?
          n = n.to_s.downcase
          result.push read_all.find{|shape| shape.downcase == n}
        end
        result
      else
        return nil if name.blank?
        name = name.to_s.downcase
        read_all.find{|shape| shape.downcase == name}
      end
    end
  end
end
