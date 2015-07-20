# switch from old dual sizes system ( both au and us with same sizes)
# to single size for all sv ( but with different presentations )
# NOTE: this migration should be runned during deploy!
# otherwise, we can decrease size for newly added dresses on au-version
#
#
class ConvertToNewSizes < ActiveRecord::Migration
  def up
    service = ExplicitSizesConvertor.new
    service.find_items_to_update
    #service.print_log
    service.print_warnings
    #service.update_items # uncomment before deploy, we can't run this many times
  end

  def down
    # strictly say, we can reverse this migration, but is this will be needed?
    # raise ActiveRecord::IrreversibleMigration.new("")
  end

  class ExplicitSizesConvertor
    attr_reader :line_items, :line_items_personalizations

    def initialize
      @us_variants_map = {}
      @log_items  = []
      @warnings   = {
        missing_variants: [],
        missing_size: [],
        empty_line_item_variant: [],  # ignore, old line items
        missing_variant_size: [],     # ignore, invalid line item
        missing_variant_color: []     # ignore, invalid line item
      }
    end

    def print_log
      puts @log_items
    end

    def print_warnings
      @warnings.each do |key, values|
        puts '-' * 50
        puts key.to_s
        puts values.sort_by{|w| w.reverse }
      end

      puts "total warnings: #{ @warnings.values.flatten.size }"
    end

    def update_items
      ActiveRecord::Base.transaction do
        line_items.each do |id, new_variant_id|
          Spree::LineItem.where(id: id).update_all(variant_id: new_variant_id)
        end
        line_items_personalizations.each do |id, size_id, size|
          LineItemPersonalization.where(id: id).update_all(size_id: size_id, size: size)
        end
      end
    end

    def find_items_to_update
      @line_items = []
      @line_items_personalizations = []

      line_items_scope.find_each do |line_item|
        if line_item.variant.blank?
          @warnings[:empty_line_item_variant].push("can't find variant for for ##{ line_item.id } #{ line_item.variant_id }")

        elsif line_item.personalization.present?
          # convert line item personalization
          product_size = get_us_product_size(line_item.personalization.size_id)
          if product_size.present?
            @line_items_personalizations.push(
              [line_item.personalization.id, product_size.id, product_size.value ]
            )
            @log_items.push(
              "personalization #{ line_item.personalization.id } will change size #{ line_item.personalization.size_id}/#{ line_item.personalization.size.value } =>  #{ product_size.id }( #{ product_size.presentation })"
            )
          else
            @warnings[:missing_size].push("can't find new size for ##{ line_item.personalization.id } #{ line_item.personalization.size_id }")
          end
        else
          # change variant
          # we have dress with au size, for example 10
          # and we should change it to 6 ( US-6 / AU-10 )
          new_variant = get_variant_with_us_size(line_item.variant)
          if new_variant.present?
            @line_items.push( [line_item.id, new_variant.id])
            @log_items.push(
              "line item #{ line_item.id } will change variant #{ line_item.variant_id }(#{ line_item.variant.dress_size.value }) => #{ new_variant.id }(#{ new_variant.dress_size.presentation })"
            )
          else
            if line_item.variant.dress_size.blank?
              @warnings[:missing_variant_size].push(
                "line item have no size #{ line_item.id } variant #{ line_item.variant_id })"
              )
            elsif line_item.variant.dress_color.blank?
              @warnings[:missing_variant_color].push(
                "line item have no size #{ line_item.id } variant #{ line_item.variant_id })"
              )
            else line_item.variant.dress_size.present?
              @warnings[:missing_variants].push("can't find new variant for #{ line_item.id } variant #{ line_item.variant_id } ( size #{ line_item.variant.dress_size.value }")
            end
          end
        end
      end
    end

    private

    def line_items_scope
      Spree::LineItem.joins(:order).where('spree_orders.currency = ?', 'AUD').includes(variant: :option_values)
    end

    # we have dress with au size, for example 10
    # and we should change it to 6 ( US-6 / AU-10 )
    def get_variant_with_us_size(au_variant)
      if @us_variants_map[au_variant.id].present?
        @us_variants_map[au_variant.id]
      else
        if au_variant.dress_color.present? && au_variant.dress_size.present?
          us_product_size = get_us_product_size(au_variant.dress_size.id)
          if us_product_size.present?
            @us_variants_map[au_variant.id] = get_product_variant(
              au_variant.product_id,
              au_variant.dress_color.id,
              us_product_size.id
            )
          else
            return nil
          end
        else
          return nil
        end
      end
    end

    def get_product_variant(product_id, color_id, size_id)
      relation = Spree::Variant.where(product_id: product_id).joins(:option_values)
      candidates = relation.where('spree_option_values_variants.option_value_id = ?', color_id).map(&:id)
      relation.where('spree_option_values_variants.variant_id in (?)', candidates).where('spree_option_values_variants.option_value_id = ?', size_id).first
    end

    def get_us_product_size(size_id)
      au_size = Repositories::ProductSize.read(size_id)
      us_size_value = au_size.value.to_i - 4
      all_sizes.find{|s| s.value == us_size_value }
    end

    def all_sizes
      @all_sizes ||= Repositories::ProductSize.read_all
    end
  end
end
