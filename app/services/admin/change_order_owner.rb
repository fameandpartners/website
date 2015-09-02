module Admin
  class ChangeOrderOwner
    attr_reader :order, :previous_owner, :new_owner, :site_version

    def initialize(order:, new_owner_id:, site_version:)
      @order          = order
      @site_version   = site_version
      @new_owner      = Spree::User.find_by_id(new_owner_id)
      @previous_owner = order.user
    end

    def process
      process!
    rescue
      false
    end

    def process!
      return false if new_owner.blank? || (previous_owner.present? && new_owner.id == previous_owner.id)

      order.user_id = new_owner.id

      # update user-related details
      order.user_first_name = new_owner.first_name
      order.user_last_name  = new_owner.last_name
      order.email           = new_owner.email

      if order.save
        notify_customer_io
        true
      end
    end

    private

      def tracker
        @tracker ||= begin
          Marketing::CustomerIOEventTracker.new.tap do |event_tracker|
            event_tracker.identify_user(new_owner, site_version)
          end
        end
      end

      def notify_customer_io
        tracker.track(new_owner, 'order:new_owner', {
          order_number: order.number,
          original_customer_email: previous_owner.try(:email),
          updated_customer_email: new_owner.email
        })
        true
      end
  end
end
