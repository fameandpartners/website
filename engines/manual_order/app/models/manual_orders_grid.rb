class ManualOrdersGrid
  include Datagrid

  scope do
    # Spree::Order.complete.where("number ILIKE 'M%' or number ILIKE 'E%'").includes(:line_items)
    # Spree::Order.find_by_sql(
    #   <<-SQL
    #     SELECT
    #       o.id as order_id,
    #       o.number,
    #       o.completed_at,
    #       li.*
    #     FROM "spree_line_items" li INNER JOIN "spree_orders" o ON o."id" = li."order_id"
    #     WHERE (o.completed_at is NOT NULL and (o.number ILIKE 'M%' or o.number ILIKE 'E%'))
    #   SQL
    # )
    Spree::LineItem.joins(:order).where("spree_orders.completed_at is NOT NULL and
      (spree_orders.number ILIKE 'M%' or spree_orders.number ILIKE 'E%')").includes(:order)
  end

  filter :number

  # decorate { |line_item| Orders::LineItemPresenter.new(line_item, Orders::OrderPresenter.new(line_item.order)) }

  column(:completed_at, header: 'Order date') {|model| model.order.completed_at.strftime("%m/%d/%y")  }
  column(:number, header: 'Order number') {|model| model.order.number}
  column(:id, header: 'Line ID') {|model| model.id}

end
