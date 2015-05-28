module Admin
  class FabricCardGrid
    attr_reader :cards, :colours

    def initialize(cards: ::FabricCard.all, colours: ::FabricColour.all)
      @cards   = cards
      @colours = colours
    end

    def by_cards
      @by_cards ||= @cards.collect do |card|
        row = [card.name]
        @colours.each do |colour|
          row << (colour_on_card(colour, card).try(:position) || '')
        end
        row
      end
    end

    def by_colours
      @by_colours ||=
        @colours.collect do |colour|
          row = [colour.name]
          @cards.each do |card|
            row << (colour_on_card(colour, card).try(:position) || '')
        end
        row
      end
    end

    private
    def colour_on_card(colour, card)
     card.fabric_card_colours.detect { |fcc| fcc.fabric_colour == colour }
    end
  end
end
