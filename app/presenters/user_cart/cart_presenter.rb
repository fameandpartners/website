module UserCart; end
class UserCart::CartPresenter < OpenStruct
  def serialize
    {
      products: products.map{|product| product.serialize },
      item_count: item_count,
      display_total: display_total
    }
  end
end
