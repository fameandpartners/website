# usage: UpdateStockQuantites.new(stock_data).process
#
# stock_data = [
#   OpenStruct sku="13016", colour="Nude", size="6", quantity=0
# ]
#
class UpdateStockQuantites
  attr_reader :stock_data

  def initialize(stock_data = [])
    @stock_data = stock_data
  end

  # prepare transactions
  # after run
  def process
    load_data

    Spree::Variant.update_all(count_on_hand: 0, on_demand: true)
    variants_data.each do |variant|
      Spree::Variant.where(id: variant.id).update_all(count_on_hand: variant.quantity, on_demand: false)
    end

    Spree::Product.update_all(count_on_hand: 0, on_demand: true)
    products_data.each do |product|
      Spree::Product.where(id: product.id).update_all(count_on_hand: product.quantity, on_demand: false)
    end

    # schedule cache cleaning
    ClearCacheWorker.perform_async(Time.now) if (Rails.env.staging? || Rails.env.production?)

    true
  end

  private

    # ensure all things can be loaded, before reseting anything
    def load_data
      variants_data
      products_data
    end

    def variants_data
      @variants_data ||= begin
        result = []

        grouped_stock_data = stock_data.group_by{|data| data.sku }

        grouped_stock_data.each do |sku, stock_data_variants|
          product = product_by_sku(sku)
          next if product.nil?

          variant_options = Products::VariantsReceiver.new(product).available_options

          stock_data_variants.each do |stock_data_variant|
            next if stock_data_variant.quantity.to_i <= 0

            size = stock_data_variant.size.to_s
            colour = stock_data_variant.colour.to_s.downcase

            variant = variant_options.find do |option|
              option[:color_presentation].to_s.downcase == colour && option[:size_presentation].to_s == size
            end

            if variant.present?
              result.push(FastOpenStruct.new(id: variant[:id], product_id: product.id, quantity: stock_data_variant.quantity))
            end
          end
        end

        result
      end
    end

    def products_data
      @products_data ||= begin
        result = []
        variants_data.group_by {|data| data.product_id }.each do |product_id, variants|
          product_on_hand = variants.sum{|variant| variant.quantity.to_i }
          if product_on_hand > 0
            result.push(FastOpenStruct.new(id: product_id, quantity: product_on_hand))
          end
        end
        result
      end
    end

    # product doesn't have sku, and variants sku have postfix like color/size
    # and sku not always the same. 1310023 => 1310023CL
    def product_by_sku(sku)
      variant = Spree::Variant.where(sku: sku).first || Spree::Variant.where("sku ilike ?", "#{ sku }%").first
      variant.try(:product)
    end
end

=begin
result = []
result = Spree::Variant.where('count_on_hand > ?', 0).map do |variant|
  row =   "#{ variant.sku } #{ variant.id } ";
  row <<  "#{ variant.dress_size.try(:name) } #{ variant.dress_color.try(:name) } ";
  row <<  " - #{ variant.count_on_hand }";
  row
end
puts result.sort
=end
