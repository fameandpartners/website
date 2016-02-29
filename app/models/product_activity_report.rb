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

  def action_count(action, product_id)
    all_actions.fetch(product_id, {}).fetch(action.to_s, 0)
  end

  # API Private

  def all_actions
    @all_actions ||= fetch_all_actions
  end

  def fetch_all_actions
    actions_sql = <<-SQL
    SELECT
      owner_id                              AS product_id,
      array_to_string(array_agg(row(action, action_count)),'|') AS stats_list
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
      memo[obj["product_id"].to_i] = stats_list_to_hash(obj["stats_list"])
      memo
    end
  end

  private def stats_list_to_hash(stats_list)
    # TODO - On upgrade to Postgres 9.4 or better, could use `json_object_agg` and a simple
    # JSON.parse on the resulting string, instead of this complicated method.
    #
    # i.e.
    # SQL: json_object_agg(action, action_count) AS stats_list
    # `JSON.parse(obj["stats_list"])`
    stats_list.to_s.split('|').inject(Hash.new(0)) do |memo, attr|
      action, value = attr.tr('()', '').split(',')
      memo[action.to_s]  = value.to_i
      memo
    end
  end
end
