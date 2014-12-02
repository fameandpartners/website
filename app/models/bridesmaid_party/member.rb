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