class StyleReport < ActiveRecord::Base
  STYLE_ATTRIBUTES = %w(glam girly classic edgy bohemian sexiness fashionability)

  default_values :glam  => 0.0,
                 :girly => 0.0,
                 :classic => 0.0,
                 :edgy => 0.0,
                 :bohemian => 0.0,
                 :sexiness => 0.0,
                 :fashionability => 0.0

  belongs_to :spree_user,
             :class_name => 'Spree::User'

  attr_accessible :bohemian,
                  :classic,
                  :edgy,
                  :girly,
                  :glam,
                  :fashionability,
                  :sexiness
end
