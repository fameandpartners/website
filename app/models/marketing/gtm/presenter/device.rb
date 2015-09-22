module Marketing
  module Gtm
    module Presenter
      class Device < Base
        attr_reader :user_agent

        def initialize(user_agent:)
          @user_agent = user_agent
        end

        def operational_system
          "#{detector.os_name} #{detector.os_full_version}"
        end

        def browser
          detector.name
        end

        def device_type
          detector.device_type
        end

        def key
          'device'.freeze
        end

        def body
          {
              browser: browser,
              os:      operational_system,
              type:    device_type
          }
        end

        private

        def detector
          ::DeviceDetector.new(user_agent)
        end
      end
    end
  end
end
