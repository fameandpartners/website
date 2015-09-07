module Marketing
  module Gtm
    class Container
      attr_reader :presenters

      def initialize(presenters: [])
        @presenters = presenters
      end

      def to_json
        base_hash = {}
        presenters.each { |presenter| base_hash[presenter.key] = presenter.body }
        base_hash.to_json
      end
    end
  end
end
