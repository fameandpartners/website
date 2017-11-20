# Because of Rails auto-loading, GlobalSku model isn't defined before the GlobalSku::Create loading, hence, `require_relative` is necessary
require_relative '../global_sku'

class GlobalSku
  class Create
    include ActiveModel::Validations

    attr_reader :style_number,
                :product_name,
                :size,
                :color_name,
                :height,
                :customizations

    validates_inclusion_of :height, in: LineItemPersonalization::HEIGHTS
    validates_inclusion_of :color_name, in: lambda { |creator| Spree::OptionValue.colors.pluck(:name) }
    validates_inclusion_of :size, in: lambda { |creator| Spree::OptionValue.sizes.pluck(:name) }
    validate :global_sku_uniqueness

    # @param [String] style_number. Example: "USP1016"
    # @param [String] product_name. Example: "Leo"
    # @param [String] size. Example: "US4/AU8"
    # @param [String] color_name. Example: "Emerald Green"
    # @param [String] height. Example: "Petite"
    # @param [Array<CustomisationValue>] customizations
    def initialize(style_number:, product_name:, size:, color_name:, height:, customizations: [])
      @style_number   = style_number
      @product_name   = product_name
      @size           = size
      @color_name     = color_name
      @height         = height
      @customizations = customizations

      normalize_parameters
    end

    # @return [GlobalSku, NilClass]
    def call
      if valid?
        GlobalSku.create!(
          sku:                generate_sku,
          style_number:       style_number,
          product_name:       product_name,
          size:               size,
          color_id:           color.id,
          color_name:         color.name,
          height_value:       height,
          customisation_id:   customization_value_ids,
          customisation_name: customization_value_names,
          product_id:         product_id,
          data:               { 'extended-style-number' => extended_style_number }
        )
      end
    end

    # Extended Style Number: an easier way for humans to read what's behind customizations
    # More at `https://fameandpartners.atlassian.net/browse/WEBSITE-1299?focusedCommentId=22330&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-22330`
    # Example: FP2212-HG-S0-F0-AK
    def extended_style_number
      customizations_map = customizations.sort{|x| ['customisation_value']['id']}.map {|x| x['customisation_value']['name']}
      [style_number].concat(customizations_map).join('-')
    end

    def generate_sku
      Skus::Generator.new(
        style_number:            style_number,
        size:                    size,
        color_id:                color&.id,
        height:                  height,
        customization_value_ids: customizations&.map { |x| x['customisation_value']['id'] }.sort
      ).call
    end

    private

    def global_sku_uniqueness
      if GlobalSku.exists?(sku: generate_sku)
        errors.add(:style_number, I18n.t('activerecord.errors.messages.taken'))
      end
    end

    def normalize_parameters
      @color_name     = @color_name.to_s.parameterize
      @height         = @height.to_s.downcase
      @customizations = Array.wrap(@customizations).compact
    end

    def product_id
      Spree::Product
        .joins(:variants_including_master)
        .where('spree_products.name ILIKE ?', product_name)
        .where('spree_variants.sku ILIKE ?', style_number)
        .where('spree_variants.is_master = ?', true)
        .pluck(:id)
        .first
    end

    def color
      Spree::OptionValue.where(name: color_name).first
    end

    def customization_value_ids
      customizations&.map {|x| x['customisation_value']['id']}.sort.join(';').presence
    end

    def customization_value_names
      customizations&.sort{|x| x['customisation_value']['id']}.map {|x| x['customisation_value']['name']}.join(';').presence # TODO: Thoroughly test this
    end
  end
end
