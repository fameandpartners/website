module Marketing
  module Gtm
    module Presenter
      class Event < Base
        attr_reader :event_name

        def initialize(event_name:)
          @event_name = event_name
        end

        def key
          'event'.freeze
        end

        def body
          event_name
        end
      end
    end
  end
end
