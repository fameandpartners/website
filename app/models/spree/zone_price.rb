# GB NOTES - This class has been causing issues, where variants already have the ability to have prices in
# multiple currencies, this class and it's usages seem to define prices for site_versions.
# TODO - Deprecate use of this, or at the very least, move it outside of the spree namespace.

class Spree::ZonePrice < ActiveRecord::Base
  belongs_to :zone
  belongs_to :variant

  validates :amount, numericality: { greater_than: 0, allow_blank: false }
  validates :amount, :currency, :variant, :zone, presence: true

  attr_accessible :amount, :currency

  def to_spree_price
    Spree::Price.new(self.attributes.except(*%w{id zone_id}))
  end
end
