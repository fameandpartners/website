module ProductActivityReport
  module_function

  def total_product_viewed(product_id)
    action_count :viewed, product_id
  end

  def total_product_added_to_cart(product_id)
    action_count :added_to_cart, product_id
  end

  def total_product_added_to_wishlist(product_id)
    action_count :added_to_wishlist, product_id
  end

  def total_product_purchased(product_id)
    action_count :purchased, product_id
  end

  # API Private

  def action_count(action, product_id)
    result = ActiveRecord::Base.connection.execute(total_actions_sql(action, product_id))

    (result.first.to_h.fetch('action_count') { 0 }).to_i
  rescue StandardError => _e
    NewRelic::Agent.notice_error(_e)
    0
  end

  def total_actions_sql(action, product_id = nil)
    actions = %w{viewed purchased added_to_cart added_to_wishlist}

    raise ArgumentError.new unless actions.include?(action.to_s)

    clauses = ["action = '#{action}'"]

    if product_id.present?
      clauses << "product_id = #{product_id.to_i}"
    end

    where_clause = clauses.join(' AND ')

    query = <<-SQL
      WITH product_total_actions AS (
          SELECT
            sum(number) AS action_count,
            action,
            owner_id    AS product_id
          FROM activities
          GROUP BY action, owner_id
      )
      SELECT
        action,
        coalesce(pta.action_count, 0) AS action_count,
        p.id                          AS product_id,
        p.name
      FROM spree_products p LEFT JOIN product_total_actions pta ON pta.product_id = p.id
      WHERE #{where_clause}
      ORDER BY action_count DESC;
    SQL
  end
end
