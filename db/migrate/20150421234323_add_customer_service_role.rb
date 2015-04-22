class AddCustomerServiceRole < ActiveRecord::Migration
  def up
    Spree::Role.create(name: 'Customer Service')
  end

  def down
    Spree::Role.where(name: 'Customer Service').first.delete
  end
end
