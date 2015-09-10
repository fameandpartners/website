module Marketing
  module Gtm
    class Container
      attr_reader :base_hash, :presenters

      def initialize(presenters: [])
        @presenters = presenters
        @base_hash  = {}
      end

      def append(presenter)
        base_hash[presenter.key] = presenter.body
      end

      def to_json
        presenters.each { |presenter| append(presenter) }
        base_hash.to_json.html_safe
      rescue StandardError => e
        NewRelic::Agent.notice_error(e)
      end
    end
  end
end
