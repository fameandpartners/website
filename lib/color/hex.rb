module Color
  class HEX
    attr_accessor :code

    def initialize(code)
      self.code = code
    end

    def to_rgb
      RGB.new(code[1..2].hex, code[3..4].hex, code[5..6].hex)
    end

    def to_lab
      self.to_rgb.to_xyz.to_lab
    end
  end
end
