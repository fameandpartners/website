Spree::Variant.class_eval do
  delegate_belongs_to :final_price, :price_without_discount if Spree::Price.table_exists?

  def in_sale?
    current_sale.active?
  end

  def options_hash
    values = self.option_values.joins(:option_type).order("#{Spree::OptionType.table_name}.position asc")

    Hash[*values.map{ |ov| [ov.option_type.presentation, ov.presentation] }]
  end

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
