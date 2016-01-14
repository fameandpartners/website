module Marketing
  module Tracking
    module Cookie
      extend ActiveSupport::Concern

      included do
        before_filter :associate_uuid_to_user
      end

      private def associate_uuid_to_user
        cookies[:user_uuid] ||= SecureRandom.uuid
      end
    end
  end
end
