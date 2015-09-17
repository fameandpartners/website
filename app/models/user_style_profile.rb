class UserStyleProfile < ActiveRecord::Base
#  BASIC_STYLES = %w(glam girly classic edgy bohemian)
#  STYLE_ATTRIBUTES = BASIC_STYLES + %w(sexiness fashionability)
#  BRANDS = %w( chanel burberry lavin christian_dior jil_sander zuhair_murad gucci sass_bide miu_miu chloe kate_spade ralph_lauren )
#  NAIL_COLOURS = %W( neon_yellow neutral mint navy black glittery lilac light_pink french_tip gold purple bright_red )
#  TRENDS = %w( jewel_tones volumnious_skirts sequins neon lace_and_mesh applique digital_prints )
#  HAIR_COLOURS = %w( black brunette auburn blonde platinum_blonde strawberry_blonde red coloured )
#  SKIN_COLOURS = %w( fair medium_fair medium medium_dark dark )
#  BODY_SHAPES = %w( apple pear athletic strawberry hour_glass column petite )
#  TYPICAL_SIZES = %w( G0 G2 G4 G6 G8 G10 G12 G14 G16 G18 G20 )
#  BRA_SIZES = %w( AAA AA A B C D E FPP )
#
#  default_values :glam  => 0.0,
#                 :girly => 0.0,
#                 :classic => 0.0,
#                 :edgy => 0.0,
#                 :bohemian => 0.0,
#                 :sexiness => 0.0,
#                 :fashionability => 0.0,
#                 :brands => [],
#                 :nail_colours => [],
#                 :colours => []
#
#  serialize :brands, Array
#  serialize :nail_colours, Array
#  serialize :colours, Array
#  serialize :serialized_answers, Hash
#
#  belongs_to :user,
#             :class_name => 'Spree::User'
#  has_many   :user_style_profile_taxons
#
#  has_one :tokenized_permission, :as => :permissable, class_name: 'Spree::TokenizedPermission'
#  delegate :token, :to => :tokenized_permission, :allow_nil => true
#  after_create :create_token
#
#  validate do
#    unless brands.all?{ |brand| BRANDS.include?(brand) }
#      errors.add(:brands, :inclusion)
#    end
#  end
#
#  validate do
#    unless nail_colours.all?{ |color| NAIL_COLOURS.include?(color) }
#      errors.add(:colors, :inclusion)
#    end
#  end
#
#  validate do
#    unless attributes.slice(*BASIC_STYLES).values.all?(&:zero?)
#      unless attributes.slice(*BASIC_STYLES).values.sum.round(2).eql?(10.0)
#        errors.add(:base, :"points_number.invalid")
#      end
#    end
#  end
#
#  #validate do
#  #  unless trends.all?{ |trend| TRENDS.include?(trend) }
#  #    errors.add(:trends, :inclusion)
#  #  end
#  #end
#
#  validates :hair_colour,
#            :inclusion => {
#              allow_blank: true,
#              in: HAIR_COLOURS
#            }
#
#  validates :skin_colour,
#            :inclusion => {
#              allow_blank: true,
#              in: SKIN_COLOURS
#            }
#
#  validates :body_shape,
#            :inclusion => {
#              allow_blank: true,
#              in: BODY_SHAPES
#            }
#
#  validates :typical_size,
#            :inclusion => {
#              allow_blank: true,
#              in: TYPICAL_SIZES
#            }
#
#  validates :bra_size,
#            :inclusion => {
#              allow_blank: true,
#              in: proc{ BRA_SIZES + %w(IT_IS_SECRET) }
#            }
#
#  def percentage
#    unless @percents.present?
#      @percents = []
#      basic_styles = attributes.slice(*BASIC_STYLES).sort_by(&:last).reverse
#      sum = basic_styles.map(&:last).reduce(:+)
#      if ((sum * 100).round == 0)
#        @percents = basic_styles
#        return @percents
#      end
#      basic_styles.each do |arr|
#        unless basic_styles.last.eql?(arr)
#          @percents << [arr.first, (arr.last / sum * 100).round ]
#        else
#          @percents << [arr.first, 100 - @percents.map(&:last).reduce(:+)]
#        end
#      end
#    end
#
#    @percents
#  end
#
#  def size_as_integer
#    typical_size.present? ? typical_size.gsub('G', '').to_i : nil
#  end
#
#  def body_shape_id
#    body_shape.present? ? BODY_SHAPES.index(body_shape) : nil
#  end
#
#  def brassiere_size
#    BRA_SIZES.include?(bra_size) ? "bra_#{bra_size.downcase}" : nil
#  end
#
#  BODY_SHAPES.each do |body_shape|
#    define_method body_shape do
#      self.body_shape.eql?(body_shape.to_s) ? 10 : 0
#    end
#  end
#
#  BRA_SIZES.each do |bra_size|
#    define_method "bra_#{bra_size.downcase}" do
#      self.bra_size.eql?(bra_size.to_s) ? 10 : 0
#    end
#  end
#
#  def active?
#    !empty_basic_styles?
#  end
#
#  def empty_basic_styles?
#    attributes.slice(*BASIC_STYLES).values.all?(&:zero?)
#  end
#
#  def create_token
#    permission = build_tokenized_permission
#    permission.token = token = ::SecureRandom::hex(8)
#    permission.save!
#    token
#  end 
#
#  class << self
#    def calculate_match(profile_a, profile_b)
#      default_value = 78
#      if profile_a.present? && profile_b.present?
#        percentage_a = Hash[profile_a.percentage]
#        percentage_b = Hash[profile_b.percentage]
#
#        diff = 0
#        percentage_a.each do |key, value|
#          diff += (percentage_b[key] - value).abs
#        end
#        diff = 20 + (diff - 20) / 5 if diff > 20
#        100 - diff
#      else
#        default_value
#      end
#    rescue
#      78 # not close, but close enough
#    end
#  end
end
