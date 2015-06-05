module Importers
  module SkuGeneration
    class FabricCardImporter < FileImporter

      def import
        preface

        csv = CSV.read(csv_file,
                       headers:           true,
                       skip_blanks:       true,
                       header_converters: ->(h) { h.to_s.strip }
        )

        csv.by_col!

        colour_names = csv.first.last.collect do |colour_name|

          colour_name.strip
        end

        fabric_card_templates = []

        csv.each_with_index do |col, idx|

          next if idx.zero?

          card_name, colour_positions = col

          info "CARD: #{card_name}"
          colour_map = colour_names.zip(colour_positions).to_h

          card = FabricCardTemplate.new(card_name, '??')
          card.colours = colour_map.reject { |_,v| v.nil? }.collect do |name, number|
            FabricCardColourTemplate.new(number, name)
          end.compact

          fabric_card_templates << card
        end


        info "BUILD MODELS"

        colour_map = colour_names.collect do |colour_name|

          info "Colour: #{colour_name}"
          [colour_name, FabricColour.find_or_create_by_name!(colour_name)]
        end.to_h



        fabric_card_templates.each do |card_template|
          warn "invalid fabric_card #{card_template.inspect}" unless card_template.valid?

          card = FabricCard.find_or_create_by_name!(card_template.name)
          info "Card: id=#{card.id}, name=#{card.name}"

          card_template.colours.each do |colour_template|

            colour = colour_map.fetch(colour_template.name) do
              warn "Missing colour: #{colour_template.name}"
            end

            FabricCardColour.find_or_create_by_fabric_card_id_and_fabric_colour_id_and_position!(
              card.id,
              colour.id,
              colour_template.number
            )
          end
        end
      end
    end
  end
end

