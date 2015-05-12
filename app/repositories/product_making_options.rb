class Repositories::ProductMakingOptions
  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read_all
    @making_options ||= begin
      product.making_options.all.map do |option|
        OpenStruct.new(
          id: option.id,
          option_type: option.option_type,
          name: option.name,
          display_price: option.display_price
        )
      end
    end
  end

  def fast_making
    read_all.detect{|item| item.option_type == 'fast_making' }
  end

  def read(id)
    read_all.detect{|item| item.id == id.to_i }
  end
end
