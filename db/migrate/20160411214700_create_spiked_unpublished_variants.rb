class CreateSpikedUnpublishedVariants < ActiveRecord::Migration
  def up
    ben_spike = [
      { style: '4B097', color: 'burgundy', size: 'US4' },
      { style: '4B123', color: 'burgundy', size: 'US6' },
      { style: '4B157', color: 'red', size: 'US0' },
      { style: '4B208', color: 'cobalt-blue', size: 'US6' },
      { style: '4B253', color: 'pale-blue', size: 'US4' },
      { style: '4B278', color: 'lemon', size: 'US4' },
      { style: '4B278', color: 'lemon', size: 'US6' },
      { style: '4B278', color: 'black', size: 'US6' },
      { style: '4B284B', color: 'navy', size: 'US4' },
      { style: '4B284B', color: 'navy', size: 'US6' },
      { style: '4B297', color: 'peach', size: 'US0' },
      { style: '4B297', color: 'apricot', size: 'US2' },
      { style: '4B300', color: 'light-pink', size: 'US8' },
      { style: '4B366', color: 'black', size: 'US4' }
    ]

    ben_spike.map do |item|
      master = Spree::Variant.where(deleted_at: nil, is_master: true, sku: item[:style]).first
      color  = Spree::OptionValue.colors.where(name: item[:color]).first
      size   = Spree::OptionValue.sizes.where('name ILIKE ?', "%#{item[:size]}%").first

      if master && color && size
        # Yeah, this is stupid
        spiked_variant = master.product.variants.includes(:option_values).select { |variant|
          variant.option_value_ids.include?(size.id) && variant.option_value_ids.include?(color.id)
        }

        if spiked_variant.blank?
          new_variant               = Spree::Variant.new
          new_variant.product       = master.product
          new_variant.option_values = [color, size]
          new_variant.deleted_at    = Time.now
          new_variant.save

          GlobalSku.find_or_create_by_spree_variant(variant: new_variant)
        end
      end
    end

  end

  def down
    # NOOP
  end
end
