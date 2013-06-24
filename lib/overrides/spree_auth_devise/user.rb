module Overrides
  module SpreeAuthDevise
    module User
      extend ActiveSupport::Concern

      included do
        devise :confirmable

        attr_accessible :first_name, :last_name

        validates :first_name,
                  :last_name,
                  :presence => true

        after_create :send_welcome_email, :unless => :confirmation_required?
        after_update :synchronize_with_campaign_monitor

        has_attached_file :avatar
      end

      SIGN_UP_VIA = %w( Email Facebook )

      def full_name
        [first_name, last_name].reject(&:blank?).join(' ')
      end

      private

      def synchronize_with_campaign_monitor
        if email_changed? || first_name_changed? || last_name_changed?
          CampaignMonitor.delay.synchronize(email_was, self)
        end
      end

      def send_welcome_email
        Spree::UserMailer.welcome(self).deliver
      end
    end
  end
end

Spree::User.send(:include, Overrides::SpreeAuthDevise::User)
