Spree::Variant.class_eval do
  before_validation :set_default_sku

  after_save do
    product.update_index
  end

  def dress_color
    get_option_value(self.class.color_option_type)
  end

  def dress_size
    get_option_value(self.class.size_option_type)
  end

  def get_option_value(option_type)
    return nil unless option_type
    self.option_values.detect do |option|
      option.option_type_id == option_type.id
    end
  end

  # Master SKU + VarientValue1 + VarientValue2
  def set_default_sku
    return if self.sku.present?
    sku_chunks = []
    master = nil

    if product.master.present?
      master = product.master
    elsif product.variants.present?
      master = product.variants.first
    end

    if master && master.sku.present?
      sku_chunks.push(master.sku)
    else
      sku_chunks.push(product.permalink)
    end

    self.option_values.order('id asc').each do |value|
      name = value.option_type.name.sub(/^dress-/, '').try(:capitalize)
      chunk = "#{name}:#{value.presentation}"
      sku_chunks.push(chunk)
    end
    sku_chunks.push(self.id.to_s)
    self.sku = sku_chunks.join('-')
  rescue Exception => e
    # do nothing, sku required for analytics mostly
    return true
  end

  class << self
    def size_option_type
      @size_option_type ||= Spree::OptionType.where(name: 'dress-size').first
    end

    def color_option_type
      @color_option_type ||= Spree::OptionType.where(name: 'dress-color').first
    end
  end
end
