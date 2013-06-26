class ProductStyleProfile < ActiveRecord::Base
  default_values :glam => 0,
                 :girly => 0,
                 :classic => 0,
                 :edgy => 0,
                 :bohemian => 0,
                 :apple => 0,
                 :pear => 0,
                 :strawberry => 0,
                 :hour_glass => 0,
                 :column => 0,
                 :bra_aaa => 0,
                 :bra_aa => 0,
                 :bra_a => 0,
                 :bra_b => 0,
                 :bra_c => 0,
                 :bra_d => 0,
                 :bra_e => 0,
                 :bra_fpp => 0,
                 :sexiness => 0,
                 :fashionability => 0

  attr_accessible :glam,
                  :girly,
                  :classic,
                  :edgy,
                  :bohemian,
                  :apple,
                  :pear,
                  :strawberry,
                  :hour_glass,
                  :column,
                  :bra_aaa,
                  :bra_aa,
                  :bra_a,
                  :bra_b,
                  :bra_c,
                  :bra_d,
                  :bra_e,
                  :bra_fpp,
                  :sexiness,
                  :fashionability

  validates :glam,
            :girly,
            :classic,
            :edgy,
            :bohemian,
            :apple,
            :pear,
            :strawberry,
            :hour_glass,
            :column,
            :bra_aaa,
            :bra_aa,
            :bra_a,
            :bra_b,
            :bra_c,
            :bra_d,
            :bra_e,
            :bra_fpp,
            :sexiness,
            :fashionability,
            :numericality => {
              :allow_blank => true,
              :only_integer => true,
              :greater_than_or_equal_to => 0,
              :less_than_or_equal_to => 10
            }

  belongs_to :product,
             :class_name => 'Spree::Product'

  after_save do
    product.update_index
  end
end
