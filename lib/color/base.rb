require 'color/hex'
require 'color/rgb'
require 'color/xyz'
require 'color/lab'

module Math
  def self.degrees(radians)
    radians * (180 / Math::PI)
  end

  def self.radians(degrees)
    degrees * Math::PI / 180
  end
end

module Color
  class Base
    def self.delta_e_cie2000(first, second, kl = 1, kc = 1, kh = 1)
      # Color 1
      l1 = first.l
      a1 = first.a
      b1 = first.b

      # Color 2
      l2 = second.l
      a2 = second.a
      b2 = second.b

      avg_lp = (l1 + l2) / 2.0
      c1 = Math.sqrt(a1**2 + b1**2)
      c2 = Math.sqrt(a2**2 + b2**2)
      avg_c1_c2 = (c1 + c2) / 2.0

      g = 0.5 * (1 - Math.sqrt( avg_c1_c2**7.0 / (avg_c1_c2**7.0 + 25.0**7.0)))

      a1p = (1.0 + g) * a1
      a2p = (1.0 + g) * a2
      c1p = Math.sqrt(a1p**2 + b1**2)
      c2p = Math.sqrt(a2p**2 + b2**2)
      avg_c1p_c2p = (c1p + c2p) / 2.0

      if Math.degrees(Math.atan2(b1, a1p)) >= 0
        h1p = Math.degrees(Math.atan2(b1, a1p))
      else
        h1p = Math.degrees(Math.atan2(b1, a1p)) + 360
      end

      if Math.degrees(Math.atan2(b2, a2p)) >= 0
        h2p = Math.degrees(Math.atan2(b2, a2p))
      else
        h2p = Math.degrees(Math.atan2(b2, a2p)) + 360
      end

      if (h1p - h2p).abs > 180
        avg_hp = (h1p + h2p + 360) / 2.0
      else
        avg_hp = (h1p + h2p) / 2.0
      end

      t = 1 - 0.17 * Math.cos(Math.radians(avg_hp - 30)) + 0.24 * Math.cos(Math.radians(2 * avg_hp)) + 0.32 * Math.cos(Math.radians(3 * avg_hp + 6)) - 0.2  * Math.cos(Math.radians(4 * avg_hp - 63))

      diff_h2p_h1p = h2p - h1p
      if diff_h2p_h1p.abs <= 180
        delta_hp = diff_h2p_h1p
      elsif diff_h2p_h1p.abs > 180 && h2p <= h1p
        delta_hp = diff_h2p_h1p + 360
      else
        delta_hp = diff_h2p_h1p - 360
      end

      delta_lp = l2 - l1
      delta_cp = c2p - c1p
      delta_hp = 2 * Math.sqrt(c2p * c1p) * Math.sin(Math.radians(delta_hp) / 2.0)

      s_l = 1 + ((0.015 * ((avg_lp - 50)**2)) / Math.sqrt(20 + ((avg_lp - 50)**2.0)))
      s_c = 1 + 0.045 * avg_c1p_c2p
      s_h = 1 + 0.015 * avg_c1p_c2p * t

      delta_ro = 30 * Math.exp(-((((avg_hp - 275) / 25)**2.0)))
      r_c = Math.sqrt(((avg_c1p_c2p**7.0)) / ((avg_c1p_c2p**7.0) + (25.0**7.0)))
      r_t = -2 * r_c * Math.sin(2 * Math.radians(delta_ro))

      Math.sqrt(
        ((delta_lp / (s_l * kl))**2) +
        ((delta_cp / (s_c * kc))**2) +
        ((delta_hp / (s_h * kh))**2) +
        r_t * (delta_cp / (s_c * kc)) * (delta_hp / (s_h * kh))
      )
    end
  end
end
