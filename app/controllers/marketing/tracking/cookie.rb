module Marketing
  module Tracking
    module Cookie
      extend ActiveSupport::Concern

      included do
        before_filter :associate_uuid_to_user
      end

      private def associate_uuid_to_user
        cookies[:user_uuid] ||= { value: SecureRandom.uuid, expires: 1.year.from_now }
      end
    end
  end
end
