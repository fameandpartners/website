module Marketing
  module Gtm
    module Controller
      module Event
        extend ActiveSupport::Concern

        private

        def append_gtm_event(event_name:)
          gtm_event = Marketing::Gtm::Presenter::Event.new(event_name: event_name)
          @gtm_container.append(gtm_event)
        end
      end
    end
  end
end
