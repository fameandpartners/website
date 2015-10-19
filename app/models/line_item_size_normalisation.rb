require 'log_formatter'
# No tests, this is essentially a frozen two step migration.
# A migration creates the Normalisation object, and then a rake task actually converts the data afterwards.

class LineItemSizeNormalisation < ActiveRecord::Base
  belongs_to :line_item,                  class_name: 'Spree::LineItem', inverse_of: :size_normalisation
  belongs_to :spree_order,                class_name: 'Spree::Order', foreign_key: :order_number, primary_key: :number
  belongs_to :line_item_personalization,  class_name: 'LineItemPersonalization'
  belongs_to :old_size,                   class_name: 'Spree::OptionValue'
  belongs_to :old_variant,                class_name: 'Spree::Variant'
  belongs_to :new_size,                   class_name: 'Spree::OptionValue'
  belongs_to :new_variant,                class_name: 'Spree::Variant'
  attr_accessible :currency, :messages, :new_size, :old_size_value, :site_version

  def self.fully_hydrated
    includes(:line_item => { :variant => { :product => { :variants => :option_values} }})
    .includes(:old_size, :new_size, :old_variant, :new_variant, :line_item_personalization)
  end

  def to_s
    "O: #{order_number} - #{line_item_id} OldSize:'#{old_size_value}' (#{old_size_id}) -> NewSize'#{new_size_value}' (#{new_size_id}) $#{currency} site:#{site_version}"
  end

  def find_new_variant
    return unless old_variant.present?
    return unless new_size_value.present?
    if old_variant.product.deleted?
      logger.warn "#{self.to_s} DELETED PRODUCT"
      self.state = :deleted_product
      save
      return
    end
    return if old_variant.is_master
    return if line_item_personalization.present?

    if old_variant.dress_color.present? && old_variant.dress_size.present?
      if old_variant.product.variants.present?

        new_variant_candidate = old_variant.product.variants.detect { |v| v.dress_size.id == new_size_id && v.dress_color == old_variant.dress_color }

        if new_variant_candidate.present?
          self.new_variant = new_variant_candidate
          logger.info "#{self.to_s} Found New Variant #{new_variant.id}"
          save
        else
          logger.warn "#{self.to_s} NO NEW VARIANT"
        end

      end
    else
      logger.error "#{self.to_s} Unknown state"
    end
  end

  def proccessed?
    !! self.processed_at.present?
  end

  def unprocessable?
    self.state == 'unprocessable'
  end

  def convert_size!
    return if proccessed?
    return if unprocessable?

    self.processed_at = DateTime.current

    if new_variant_id.present?
      Spree::LineItem.where(id: line_item_id).update_all(variant_id: new_variant_id)
      self.state = :new_variant_set
    elsif line_item_personalization.present? && new_size.present?

      LineItemPersonalization.where(id: line_item_personalization.id).update_all(size_id: new_size.id, size: new_size.name)
      self.state = :update_personalization

    else
      self.state = :no_variant_or_personalisation
    end

    self.save!
  end

  attr_writer :logger
  def logger
    @logger ||= begin
      new_logger = Logger.new($stdout)
      new_logger.level     = Logger::WARN
      new_logger.formatter = LogFormatter.terminal_formatter
      new_logger
    end
  end

  class Normaliser
    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    def initialize(logdev: $stdout)
      @logger           = Logger.new(logdev)
      @logger.level     = Logger::INFO
      @logger.formatter = LogFormatter.terminal_formatter
    end


    # {
    # 0=>86, 2=>34, 4=>20, 6=>21, 8=>22, 10=>23, 12=>24, 14=>149, 16=>148,
    # 18=>147, 20=>146, 22=>145, 24=>180, 26=>181
    # }
    def sizes
      @sizes = Spree::OptionType.size.option_values.collect { |sz| [sz.name.to_i, sz.id] }.to_h
    end

    def new_size_value(old_size_value)
      old_size_value.to_i - 4
    end

    def size_id(value)
      sizes[value.to_i]
    end

    def build_normalisations
      line_items_scope.find_each do |line_item|
        # info line_item.id
        begin
          normalisation = LineItemSizeNormalisation.new
          normalisation.order_number              = line_item.order.number
          normalisation.order_created_at          = line_item.order.created_at
          normalisation.line_item                 = line_item
          normalisation.line_item_personalization = line_item.personalization
          normalisation.old_variant               = line_item.variant
          normalisation.currency                  = line_item.order.currency
          normalisation.site_version              = line_item.order.site_version
          normalisation.state = :unconverted

          if line_item.personalization
            # info  "PERSONALISED #{line_item.id}"
            normalisation.old_size_id    = line_item.personalization.size_id
            normalisation.old_size_value = line_item.personalization.attributes['size']

          elsif line_item.variant && line_item.variant.dress_size.present?

            normalisation.old_size_id    = line_item.variant.dress_size.id
            normalisation.old_size_value = line_item.variant.dress_size.name

          elsif line_item.variant &&  line_item.variant.is_master && line_item.personalization.blank?

            normalisation.messages = "Master Variant with no personalisation"
            normalisation.state = :unprocessable
            warn  "Master Variant with no personalisation #{line_item.id} "

          elsif line_item.variant.blank?

            normalisation.messages = "No Variant Found"
            normalisation.state = :unprocessable
            warn  "No Variant Found #{line_item.id}"

          else
            error "Unknown & unsupported condition #{line_item.id}"
          end

          if normalisation.old_size_value
            new_size_value = new_size_value(normalisation.old_size_value)
            if new_size_value >= 0
              normalisation.new_size_id    = size_id(new_size_value)
              normalisation.new_size_value = new_size_value
            else
              normalisation.messages = "Unchangeable size (#{normalisation.old_size_value})-(#{new_size_value})"
              normalisation.state = :unprocessable
            end
          end

          info normalisation
          normalisation.save

        rescue StandardError => e
          error e.message
        end
      end
    end

    def line_items_scope
      Spree::LineItem
        .includes(variant: :option_values)
        .joins(:order => { :ship_address => :country })
        .where("spree_orders.site_version = 'au'")
    end
  end
end
