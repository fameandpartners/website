module Marketing
  module Gtm
    module Presenter
      class Page < Base
        attr_reader :type

        def initialize(type:)
          @type             = type
        end

        def key
          'page'.freeze
        end

        def body
          {
              type:            type,
          }
        end
      end
    end
  end
end
