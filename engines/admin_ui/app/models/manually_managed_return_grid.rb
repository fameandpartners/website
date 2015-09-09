require 'datagrid'

class ManuallyManagedReturnGrid
  include Datagrid

  scope do
    ManuallyManagedReturn
  end

  ManuallyManagedReturn.new.attributes.keys.map do |col|
    column col
  end

  def self.values_for(column_name)
    ManuallyManagedReturn.pluck(column_name).uniq
  end

  filter(:spree_order_number, :string)
  filter(:receive_state, :enum, :select => values_for(:receive_state))
  filter(:return_cancellation_credit, :enum, :select => values_for(:return_cancellation_credit))
  filter(:refund_status, :enum, :select => values_for(:refund_status))
end
