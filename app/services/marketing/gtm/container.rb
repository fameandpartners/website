module Marketing
  module GTM
    class Container
      attr_reader :pieces

      def initialize(pieces: [])
        @pieces = pieces
      end

      def to_json
        base_hash = {}
        pieces.each { |piece| base_hash[piece.key] = piece.body }
        base_hash.to_json
      end
    end
  end
end

# piece_a = OpenStruct.new(key: :a, body: { something: 'new' })
# piece_b = OpenStruct.new(key: :b, body: { other: 'something' })
# Marketing::GTM::Container.new(pieces: [piece_a, piece_b]).to_json
