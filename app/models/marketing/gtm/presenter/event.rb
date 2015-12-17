module Marketing
  module Gtm
    module Presenter
      class Event < Base
        attr_reader :event

        def initialize(event:)
          @event = event
        end

        def key
          'event'.freeze
        end

        def body
          { name: event }
        end
      end
    end
  end
end
