module Marketing
  module Gtm
    module Presenter
      class Base
        UNKNOWN_STRING = 'unknown'.freeze

        def key
          raise NotImplementedError, '#key is not yet implemented'
        end

        def body
          raise NotImplementedError, '#body is not yet implemented'
        end

        def rescuable_body
          body
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
          { error: e.message }
        end
      end
    end
  end
end
