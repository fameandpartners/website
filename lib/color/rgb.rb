module Color
  class RGB
    attr_accessor :red,
                  :green,
                  :blue

    def initialize(red, green, blue)
      self.red   = red
      self.green = green
      self.blue  = blue
    end

    def to_xyz
      red   = self.red   / 255.0
      green = self.green / 255.0
      blue  = self.blue  / 255.0

      if red > 0.04045
        red = (red + 0.055) / 1.055
        red = red**2.4
      else
        red = red / 12.92
      end

      if green > 0.04045
        green = (green + 0.055) / 1.055
        green = green**2.4
      else
        green = green / 12.92
      end

      if blue > 0.04045
        blue = (blue + 0.055) / 1.055
        blue = blue**2.4
      else
        blue = blue / 12.92
      end

      red   *= 100
      green *= 100
      blue  *= 100

      x = red * 0.4124 + green * 0.3576 + blue * 0.1805
      y = red * 0.2126 + green * 0.7152 + blue * 0.0722
      z = red * 0.0193 + green * 0.1192 + blue * 0.9505

      XYZ.new(x, y, z)
    end
  end
end
