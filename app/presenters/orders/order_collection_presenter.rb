class OrderCollectionPresenter
  attr_reader :orders

  def initialize(orders)
    @orders = orders
  end
end