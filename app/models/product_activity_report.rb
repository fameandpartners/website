module ProductActivityReport
  module_function

  def total_product_viewed(product_id)
    action_count2 :viewed, product_id
  end

  def total_product_added_to_cart(product_id)
    action_count2 :added_to_cart, product_id
  end

  def total_product_added_to_wishlist(product_id)
    action_count2 :added_to_wishlist, product_id
  end

  def total_product_purchased(product_id)
    action_count2 :purchased, product_id
  end

  def all_actions
    @all_actions ||= fetch_all_actions
  end


  def action_count2(action, product_id)
    all_actions.fetch(product_id, Hash.new(0))[action.to_s]
  end

  def fetch_all_actions
    actions_sql = <<-SQL
    SELECT
      owner_id                              AS product_id,
      json_object_agg(action, action_count) AS stats_list
    FROM (
           SELECT
             DISTINCT
             owner_id,
             action,
             coalesce(sum(number)
                      OVER (w), 0) AS action_count
           FROM activities
           WHERE
             owner_type = 'Spree::Product'
           WINDOW w AS (
             PARTITION BY action, owner_id )
         ) AS row
    GROUP BY owner_id
    SQL

    actions_results = ActiveRecord::Base.connection.execute(actions_sql)

    actions_results.inject(Hash.new(0)) do |memo, obj|
      memo[obj["product_id"].to_i] = JSON.parse(obj["stats_list"])
      memo
    end
  end

  # API Private

  def action_count(action, product_id, default_value: 0)
    result = ActiveRecord::Base.connection.execute(total_actions_sql(action, product_id))

    (result.first.to_h.fetch('action_count') { default_value }).to_i
  rescue StandardError => _e
    NewRelic::Agent.notice_error(_e)
    default_value
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
