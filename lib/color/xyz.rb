module Color
  class XYZ
    attr_accessor :x,
                  :y,
                  :z

    def initialize(x, y, z)
      self.x = x
      self.y = y
      self.z = z
    end

    def to_lab
      x = self.x / 95.047
      y = self.y / 100
      z = self.z / 108.883

      if x > 0.008856
        x = x**(1.0 / 3.0)
      else
        x = 7.787 * x + 16.0 / 116.0
      end

      if y > 0.008856
        y = y**(1.0 / 3.0)
      else
        y = 7.787 * y + 16.0 / 116.0
      end

      if z > 0.008856
        z = z**(1.0 / 3.0)
      else
        z = 7.787 * z + 16.0 / 116.0
      end

      l = 116 * y -16
      a = 500 * (x - y)
      b = 200 * (y - z)

      Lab.new(l, a, b)
    end
  end
end
