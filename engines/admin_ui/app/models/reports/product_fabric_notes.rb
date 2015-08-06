require 'enumerable_csv'

module Reports
  class ProductFabricNotes
    include ::EnumerableCSV

    def each
      return to_enum(__callee__) unless block_given?

      scope.find_each do |prod|
        yield present(prod)
      end
    end

    private def present(prod)
      {sku: prod.sku, name: prod.name, fabric_notes: prod.property('fabric')}
    end

    private def scope
      Spree::Product.active
    end
  end
end
