class StyleReport < ActiveRecord::Base
  BASIC_STYLES = %w(glam girly classic edgy bohemian)
  STYLE_ATTRIBUTES = %w(glam girly classic edgy bohemian sexiness fashionability)

  BRANDS = %w( chanel burberry lavin christian_dior jil_sander zuhair_murad gucci sass_bide miu_miu chloe kate_spade ralph_lauren )

  COLORS = %W( neon_yellow neutral mint navy black glittery lilac light_pink french_tip gold purple bright_red )

  default_values :glam  => 0.0,
                 :girly => 0.0,
                 :classic => 0.0,
                 :edgy => 0.0,
                 :bohemian => 0.0,
                 :sexiness => 0.0,
                 :fashionability => 0.0,
                 :brands => [],
                 :colors => []

  serialize :brands, Array
  serialize :colors, Array

  belongs_to :spree_user,
             :class_name => 'Spree::User'

  validate do
    unless brands.all?{ |brand| BRANDS.include?(brand) }
      errors.add(:brands, :inclusion)
    end
  end

  validate do
    unless colors.all?{ |color| COLORS.include?(color) }
      errors.add(:colors, :inclusion)
    end
  end

  def percentage
    unless @percents.present?
      basic_styles = attributes.slice(*BASIC_STYLES)
      sum = basic_styles.values.reduce(:+)
      @percents = basic_styles.sort_by(&:last).reverse.map do |arr|
        [arr.first, (arr.last / sum * 100).round ]
      end
    end

    @percents
  end
end
