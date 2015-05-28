require 'spec_helper'

module Admin
  RSpec.describe FabricCardGrid do

    subject(:grid) do
      colours = [
        _red  = double('red',   name: 'red'),
        green = double('green', name: 'green'),
        blue  = double('blue',  name: 'blue')
      ]

      cards = [
        instance_spy('FabricCard',
          name: 'canvas',
          fabric_card_colours:
            [ instance_spy('FabricCardColour', position: 'blue99', fabric_colour: blue) ]
        ),
        instance_spy('FabricCard',
           name: 'burlap',
           fabric_card_colours:
            [ instance_spy('FabricCardColour', position: 'green88', fabric_colour: green) ]
        )
      ]

      described_class.new cards: cards, colours: colours
    end

    it 'fills sparse colour values' do
      expect(grid.by_colours).to eq([
                                      ['red',   '',       ''       ],
                                      ['green', '',       'green88'],
                                      ['blue',  'blue99', ''       ],
                                    ])
    end

    it 'fills sparse card values' do
      expect(grid.by_cards).to eq([
                                      ['canvas', '', '',        'blue99' ],
                                      ['burlap', '', 'green88', ''       ],
                                    ])
    end
  end
end

