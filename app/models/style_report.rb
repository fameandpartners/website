class StyleReport < ActiveRecord::Base
  STYLE_ATTRIBUTES = %w(glam girly classic edgy bohemian sexiness fashionability)

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
