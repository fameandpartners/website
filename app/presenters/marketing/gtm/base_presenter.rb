module Marketing
  module Gtm
    class BasePresenter
      UNKNOWN_STRING = 'unknown'.freeze

      def key
        raise NotImplementedError, '#key is not yet implemented'
      end

      def body
        raise NotImplementedError, '#body is not yet implemented'
      end
    end
  end
end
