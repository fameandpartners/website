require 'datagrid'

module AdminUi
  class VariantsController < AdminUi::ApplicationController

    class VariantsGrid
      include ::Datagrid

      scope do
        Spree::Variant
          .active
          .includes(:option_values, :option_values, :product)
          .where(product_id: Spree::Product.active)
      end

      filter :name, label: 'Product' do |value|
        where("spree_products.name ilike ?", "%#{value}%")
      end
      filter :is_master, :xboolean

      filter(:dress_color, :enum, select: ->{ Spree::OptionType.color.option_values.map {|c| ["#{c.name} (#{c.presentation})", c.id] } }) do |value|
        where("spree_option_values.id = ?", value)
      end
      filter(:dress_size, :enum, select: ->{ Spree::OptionType.size.option_values.map {|c| [c.name, c.id] } }) do |value|
        where("spree_option_values.id = ?", value)
      end

      column(:name,
            order: ->(scope) { scope.order('spree_products.name')}
      ) do |variant|
        format(variant.name) do |name|
          link_to(name, spree.admin_product_path(variant.product))
        end
      end
      column :id, label: 'Variant' do |variant|
        format(variant.id) do |name|
          link_to(name, spree.edit_admin_product_variant_path(variant.product, variant))
        end
      end
      column :dress_color do |x|
        x.dress_color.try(:name)
      end
      column :dress_size do |x|
        x.dress_size.try(:name)
      end

      column :sku, label: 'SKU'

      column :style_number, label: 'Style Number'  do |variant|
        variant.product.master.sku
      end

    end

    def index
      @collection = VariantsGrid.new(params[:admin_ui_variants_controller_variants_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(300) }
        end
        f.csv do
          send_data @collection.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "variants-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end
  end
end
