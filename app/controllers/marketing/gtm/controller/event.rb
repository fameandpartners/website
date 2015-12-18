module Marketing
  module Gtm
    module Controller
      module Event
        extend ActiveSupport::Concern

        private

        def append_gtm_event(event:)
          gtm_event = Marketing::Gtm::Presenter::Event.new(event: event)
          @gtm_container.append(gtm_event)
        end
      end
    end
  end
end
