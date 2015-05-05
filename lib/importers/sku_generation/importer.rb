require 'ruby-progressbar'

module Importers
  module SkuGeneration
    class Importer < FileImporter

      attr_accessor :product_templates
      attr_accessor :progress

      def import
        preface
        parse_file
        export_comparison_csv
        info "Done"
      end

      def parse_file
        csv = CSV.read(csv_file,
                       headers: true,
                       skip_blanks: true,
                       header_converters: ->(h){ h.strip }
        )

        @product_templates = product_style_rows(csv).collect do |style_number, rows|
          main_row   = rows.first
          style_name = main_row["STYLE NAME"]
          fabric_sku_component = main_row["SKU CODE"].gsub(style_number, '').gsub(/\s+/, '')

          sku_template = TemplateProduct.new(style_number, style_name)
          sku_template.base_sizes  = BaseSize.size_set
          sku_template.fabric_card = FabricCard.new(main_row['FABRIC'], fabric_sku_component)

          sku_template.fabric_card.colours = rows.collect do |row|
            next if row["COLOUR #"].nil? && row['COLOUR'].nil?
            colour = FabricCardColour.new(row["COLOUR #"], row['COLOUR'])

            error "Invalid Colour for #{style_number} #{style_name}  number='#{colour.number}' name='#{colour.name}' " unless colour.valid?
            colour
          end.compact

          sku_template
        end
      end

      def product_style_rows(csv)
        csv.chunk({current_style_number: :unknown}) do |row, state|
          if row["STYLE NUMBER"] && row["STYLE NUMBER"] != state[:current_style_number]
            state[:current_style_number] = row["STYLE NUMBER"]
          else
            state[:current_style_number]
          end
        end
      end

      def export_filled_csv
        fp = File.join(Rails.root, 'tmp', 'filled_product_skus.csv')

        csv_string = CSV.generate(headers: true) do |csv|
          csv << ['STYLE NUMBER', 'STYLE NAME', 'FABRIC', 'SKU CODE', 'COLOUR #', 'COLOUR','SIZE (AU)','FINAL SKU']

          product_templates.each do |product|
            product.variants.each do |variant|
              csv << [
                variant.product.style_number,
                variant.product.style_name,
                variant.fabric_card.name,
                variant.fabric_card.sku_component,
                variant.colour.number,
                variant.colour.name,
                variant.size.size,
                variant.sku
              ]
            end
          end
        end
        File.write(fp, csv_string)

        info "Wrote #{fp}"
      end

      def export_comparison_csv
        fp = File.join(Rails.root , 'tmp',  'generated_skus_vs_spree_products.csv')
        progressbar = ProgressBar.create(
          :total => product_templates.count,
          :format => 'Product: %c/%C  |%w%i|'
        )

        csv_string = generate_comparison_csv(progressbar)

        File.write(fp, csv_string)

        progressbar.finish
        info "Wrote #{fp}"
      end

      def generate_comparison_csv(progress = nil)
        CSV.generate(headers: true) do |csv|
          generate_comparison(progress).each do |row|
            csv << row
          end
        end
      end

      def generate_comparison(progress = nil)
        rows = []
        rows << [
          'STYLE NUMBER',
          'STYLE NAME',
          'FABRIC',
          'SKU CODE',
          'COLOUR #',
          'COLOUR',
          'SIZE (AU)',
          'FINAL SKU',
          :spree_known_colour,
          :spree_variant_sku,
          :spree_color,
          :spree_size
        ]

        product_templates.each do |product|
          progress.try(:increment)

          spree_variants = spree_variant_hashes_for_style(product.style_number)
          matched_variants = []

          product.variants.each do |variant|

            matching_variant = spree_variants.detect { |spv|
              spv[:color].downcase == variant.colour.name.downcase &&
                spv[:size] == variant.size.size.to_s
            }
            matched_variants << matching_variant if matching_variant
            matching_variant ||= {}

            rows << [
              variant.product.style_number,
              variant.product.style_name,
              variant.fabric_card.name,
              variant.fabric_card.sku_component,
              variant.colour.number,
              variant.colour.name,
              variant.size.size,
              variant.sku,
              spree_colour_for_variant(variant),
              matching_variant.fetch(:sku) { '-' },
              matching_variant.fetch(:color) { '-' },
              matching_variant.fetch(:size) { '-' }
            ]
          end

          (spree_variants - matched_variants).sort_by{|v| [v[:color],v[:size]] }.each do |non_matched_variant|
            rows << [
              product.style_number,
              product.style_name,
              nil,
              nil,
              nil,
              nil,
              nil,
              '-',
              '-',
              non_matched_variant[:sku],
              non_matched_variant[:color],
              non_matched_variant[:size]
            ]
          end
        end

        rows
      end

      private

      def spree_colour_for_variant(variant)
        known_colours.detect { |c| c.downcase == variant.colour.name.downcase } || :no_colour_match
      end

      def known_colours
        @known_colours ||= begin
          Spree::OptionValue
            .joins(:option_type)
            .where('spree_option_types.name' => 'dress-color')
            .pluck(:presentation)
        end
      end

      def spree_variant_hashes_for_style(style_number)
        spree_product = Spree::Product
                          .where(deleted_at: nil)
                          .includes(:variants)
                          .where(Spree::Variant.arel_table[:sku].matches(style_number)
                          ).first

        if spree_product
          spree_product.variants.reject(&:is_master).collect do |v|
            {
              color: v.dress_color.try(:presentation) || :spree_missing_color,
              size:  v.dress_size.try(:presentation) || :spree_missing_size,
              sku:   v.sku
            }
          end
        else
          []
        end
      end
    end
  end
end
