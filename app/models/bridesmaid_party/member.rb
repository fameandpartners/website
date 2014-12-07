module BridesmaidParty
  class Member < ActiveRecord::Base
    self.table_name = :bridesmaid_party_members

    attr_accessible :first_name, :last_name, :email

    belongs_to :event
    belongs_to :spree_user, class_name: 'Spree::User'

    before_validation :generate_token, on: :create

    validates :token,
              presence: true,
              uniqueness: true

    validates :email,
              presence: true,
              uniqueness: {
                allow_blank: true,
                scope: :event_id
              },
              format: {
                allow_blank: true,
                with: Devise.email_regexp
              }

    default_value_for :customization_value_ids, []
    serialize :customization_value_ids, Array

    belongs_to :variant, class_name: 'Spree::Variant', foreign_key: 'variant_id'

    def full_name
      [first_name, last_name].reject(&:blank?).join(' ')
    end

    def generate_token
      self.token = self.class.token
    end

    class << self
      def token
        generate_token(:token)
      end

      def generate_token(column)
        loop do
          token = SecureRandom.urlsafe_base64(24)
          break token unless exists?({ column => token })
        end
      end
    end
  end
end
