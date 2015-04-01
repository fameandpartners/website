module Overrides
  module SpreeAuthDevise
    module User
      extend ActiveSupport::Concern

      included do
        attr_accessor :skip_welcome_email
        attr_accessible :first_name, :last_name

        validates :first_name,
                  :last_name,
                  :presence => true

        after_create :send_welcome_email, unless: Proc.new { |a| a.skip_welcome_email }
        after_update :synchronize_with_campaign_monitor

        has_attached_file :avatar
        has_one :style_profile,
                :class_name => '::UserStyleProfile',
                :foreign_key => :user_id

      def full_name
        [first_name, last_name].reject(&:blank?).join(' ')
      end

      def sign_up_via_facebook?
        sign_up_via.eql?(1)
      end

      private

        def synchronize_with_campaign_monitor
          if email_changed? || first_name_changed? || last_name_changed?
            CampaignMonitor.delay.synchronize(email_was, self)
          end
        end

        def send_welcome_email
          return true if Rails.application.config.skip_mail_delivery
          unless skip_welcome_email
            ::Spree::UserMailer.welcome(self).deliver
          end
        end
      end
    end
  end
end

Spree::User.send(:include, Overrides::SpreeAuthDevise::User)
