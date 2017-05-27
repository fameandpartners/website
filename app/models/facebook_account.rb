class FacebookAccount < ActiveRecord::Base
  attr_accessible :account_status, :amount_spent, :currency, :facebook_id, :name, :age

  def self.update_from_json( account_json )
    account = FacebookAccount.find_or_create_by_facebook_id( facebook_id: account_json['id'] )
    account.update_attributes!( account_status: account_json['account_status'], amount_spent: account_json['amount_spent'], currency: account_json['currency'], name: account_json['name'], age: account_json['age'] )
    account
  end
  
end
