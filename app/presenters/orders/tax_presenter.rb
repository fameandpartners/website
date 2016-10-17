require 'forwardable'

module Orders
  class TaxPresenter
    extend Forwardable

    attr_reader :tax, :order
    def_delegators :tax, :label

    def initialize(spree_adjustment:, spree_order:)
      @tax   = spree_adjustment
      @order = spree_order
    end

    def display_tax_total
      Spree::Money.new(tax.amount, { currency: order.currency }).to_s
    end

    def to_h
      { label: label, display_tax_total: display_tax_total }
    end
  end
end
