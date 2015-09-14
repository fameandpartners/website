module Spree
  class MasterpassCheckout < ActiveRecord::Base
    attr_accessible :access_token, :account_number, :billing_address, :birthday, :brand_id, :cardholder_name, :contact_name, :email, :exp_date, :gender, :national_id, :phone, :precheckout_transaction_id, :transaction_id

    belongs_to :order
  end
end
