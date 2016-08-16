class ManualOrdersGrid
  include Datagrid

  scope do
    Spree::Order.complete.where("number ILIKE 'M%' or number ILIKE 'E%'")
  end

  filter :number

  column :id
  column :number

end
