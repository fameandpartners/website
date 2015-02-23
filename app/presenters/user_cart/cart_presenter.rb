module UserCart; end
class UserCart::CartPresenter < OpenStruct
  def serialize
    {
      products: products.map{|product| product.serialize },
      item_count: item_count,
      total: total
    }
  end
end
