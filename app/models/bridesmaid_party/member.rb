module BridesmaidParty
  class Member < ActiveRecord::Base
    self.table_name = :bridesmaid_party_members

    belongs_to :event

    attr_accessible :first_name, :last_name, :email
  end
end