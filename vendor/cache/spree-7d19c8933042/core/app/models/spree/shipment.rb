require 'ostruct'

module Spree
  class Shipment < ActiveRecord::Base
    belongs_to :order
    belongs_to :shipping_method
    belongs_to :address

    has_many :state_changes, :as => :stateful
    has_many :inventory_units, :dependent => :nullify
    has_one :adjustment, :as => :source, :dependent => :destroy

    before_create :generate_shipment_number
    after_save :ensure_correct_adjustment, :update_order

    attr_accessor :special_instructions

    attr_accessible :order, :shipping_method, :special_instructions,
                    :shipping_method_id, :tracking, :address, :inventory_units

    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :inventory_units

    validates :inventory_units, :presence => true, :if => :require_inventory
    validates :shipping_method, :presence => true

    make_permalink :field => :number

    scope :with_state, lambda { |s| where(:state => s) }
    scope :shipped, with_state('shipped')
    scope :ready, with_state('ready')
    scope :pending, with_state('pending')

    def to_param
      number if number
      generate_shipment_number unless number
      number.to_s.to_url.upcase
    end

    def shipped=(value)
      return unless value == '1' && shipped_at.nil?
      self.shipped_at = Time.now
    end

    def currency
      order.nil? ? Spree::Config[:currency] : order.currency
    end

    # The adjustment amount associated with this shipment (if any.)  Returns only the first adjustment to match
    # the shipment but there should never really be more than one.
    def cost
      adjustment ? adjustment.amount : 0
    end

    alias_method :amount, :cost

    def display_cost
      Spree::Money.new(cost, { :currency => currency })
    end

    alias_method :display_amount, :display_cost

    # shipment state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
    state_machine :initial => 'pending', :use_transactions => false do
      event :ready do
        transition :from => 'pending', :to => 'ready', :if => lambda { |shipment|
          # Fix for #2040
          shipment.determine_state(shipment.order) == 'ready'
        }
      end
      event :pend do
        transition :from => 'ready', :to => 'pending'
      end
      event :ship do
        transition :from => 'ready', :to => 'shipped'
      end

      after_transition :to => 'shipped', :do => :after_ship
    end

    def editable_by?(user)
      !shipped?
    end

    def manifest
      inventory_units.group_by(&:variant).map do |i|
        OpenStruct.new(:variant => i.first, :quantity => i.last.length)
      end
    end

    def line_items
      if order.complete? and Spree::Config[:track_inventory_levels]
        order.line_items.select { |li| inventory_units.pluck(:variant_id).include?(li.variant_id) }
      else
        order.line_items
      end
    end

    # Updates various aspects of the Shipment while bypassing any callbacks.  Note that this method takes an explicit reference to the
    # Order object.  This is necessary because the association actually has a stale (and unsaved) copy of the Order and so it will not
    # yield the correct results.
    def update!(order)
      old_state = state
      new_state = determine_state(order)
      update_column 'state', new_state
      after_ship if new_state == 'shipped' and old_state != 'shipped'
    end

    # Determines the appropriate +state+ according to the following logic:
    #
    # pending    unless order is complete and +order.payment_state+ is +paid+
    # shipped    if already shipped (ie. does not change the state)
    # ready      all other cases
    def determine_state(order)
      return 'pending' unless order.can_ship?
      return 'pending' if inventory_units.any? &:backordered?
      return 'shipped' if state == 'shipped'
      order.paid? ? 'ready' : 'pending'
    end

    private
      def generate_shipment_number
        return number unless number.blank?
        record = true
        while record
          random = "H#{Array.new(11) { rand(9) }.join}"
          record = self.class.where(:number => random).first
        end
        self.number = random
      end

      def description_for_shipping_charge
        "#{I18n.t(:shipping)} (#{shipping_method.name})"
      end

      def validate_shipping_method
        unless shipping_method.nil?
          errors.add :shipping_method, I18n.t(:is_not_available_to_shipment_address) unless shipping_method.zone.include?(address)
        end
      end

      # Determines whether or not inventory units should be associated with the shipment.  This is always +false+ when
      # +Spree::Config[:track_inventory_levels]+ is set to +false.+  Otherwise its +true+ whenever the order is completed
      # (and not canceled.)
      def require_inventory
        return false unless Spree::Config[:track_inventory_levels]
        order.completed? && !order.canceled?
      end

      def after_ship
        inventory_units.each do |iu|
          # special manual order case
          if order.number.downcase.starts_with? 'm'
            iu.state = 'sold'
          end
          iu.ship!
        end
        send_shipped_email
        touch :shipped_at
      end

      def send_shipped_email
        ShipmentMailer.shipped_email(self.id).deliver
      end

      def ensure_correct_adjustment
        if adjustment
          adjustment.originator = shipping_method
          adjustment.label = shipping_method.adjustment_label
          adjustment.save
        else
          shipping_method.create_adjustment(shipping_method.adjustment_label, order, self, true)
          reload #ensure adjustment is present on later saves
        end
      end

      def update_order
        order.update!
      end
  end
end
