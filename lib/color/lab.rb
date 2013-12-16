module Color
  class Lab
    attr_accessor :lightness,
                  :a,
                  :b

    alias :l :lightness

    def initialize(lightness, a, b)
      self.lightness = lightness
      self.a = a
      self.b = b
    end
  end
end
