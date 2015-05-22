module Products
  module Collection
    Dress = Struct.new(:id, :name, :color, :images, :price, :discount, :fast_delivery) do
      def self.from_hash(hash)
        instance = new
        hash.map { |k,v| instance[k] = v }
        instance
      end
    end
  end
end
