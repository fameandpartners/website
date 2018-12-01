module AdminUi
  class ProductTaxonsController < AdminUi::ApplicationController
    before_filter :load_products_and_taxons

    def index
    end

    def apply
      @toolbar_state.each do |directive|
        if ( (directive["original_state"] == "fa-square-o" && directive["current_state"] == "fa-check-square") ||
             (directive["original_state"] == "fa-minus-square" && directive["current_state"] == "fa-check-square") )
          @checked_products.each do |product_id|
            unless Spree::Product.find(product_id).taxons.where(id: directive["taxon_id"].to_i).present?
              Spree::Product.find(product_id).taxons << Spree::Taxon.find(directive["taxon_id"])
            end
          end
        elsif ( (directive["original_state"] == "fa-check-square" && directive["current_state"] == "fa-square-o") ||
                (directive["original_state"] == "fa-minus-square" && directive["current_state"] == "fa-square-o") )
          @checked_products.each do |product_id|
            Spree::Product.find(product_id).taxons.delete( Spree::Taxon.find(directive["taxon_id"]) )
          end
        end
      end
    end

    def dropdown
    end

    private

    def load_products_and_taxons
      @products = Spree::Product.unscoped.where('deleted_at IS NULL').order("created_at DESC")
      @table_state = params["table_state"] ? (params["table_state"].map { |k,v| v}) : []
      @toolbar_state = params["toolbar_state"] ? (params["toolbar_state"].map { |k,v| v}) : []
      @checked_products = @table_state.select { |x| x["is_checked"]=="1" }.map do |ts|
        ts["product_id"].to_i
      end
      num_checked_products = @checked_products.size

      @all_taxons = Spree::Taxon.order(:name).map do |taxon|
        num_products_having_taxon = 0

        if num_checked_products > 0
          num_products_having_taxon = ActiveRecord::Base.connection.execute(
            "select count(*) from spree_products_taxons " \
            "where taxon_id=#{taxon.id} AND " \
            "product_id IN (#{@checked_products.join(',')})"
          ).to_a[0]["count"].to_i
        end
        state = "fa-square-o"
        state = "fa-minus-square" if num_products_having_taxon > 0
        state = "fa-check-square" if num_products_having_taxon == num_checked_products && num_checked_products!=0
        { taxon_id: taxon.id, name: taxon.name, state: state, toggleable_states: toggleable_states(state) }
      end
    end

    def toggleable_states(state)
      if state == "fa-square-o"
        "fa-check-square,fa-square-o"
      elsif state == "fa-minus-square"
        "fa-check-square,fa-square-o,fa-minus-square"
      elsif state == "fa-check-square"
        "fa-square-o,fa-check-square"
      end
    end

  end
end
