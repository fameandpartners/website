class Factory
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_s
    name.to_s
  end

  def self.for_product(product)
    new(product.property(:factory_name).presence || 'Unknown')
  end
end