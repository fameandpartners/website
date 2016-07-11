module Marketing
  module Gtm
    module Presenter
      class Container
        attr_reader :base_hash, :presenters

        def initialize(presenters: [])
          @presenters = presenters
          @base_hash  = {}
        end

        def append(presenter)
          base_hash[presenter.key] = presenter.rescuable_body
        end

        def append_single_variable(key, value)
          base_hash[key] = value
        end

        def append_variables(hash)
          hash.each { |key, value| base_hash[key.to_s] = value }
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
end
