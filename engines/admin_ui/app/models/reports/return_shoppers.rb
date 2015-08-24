module Reports
  class ReturnShoppers
    include RawSqlCsvReport

    def description
      'ReturnShoppers'
    end

    def to_sql
      <<-SQL
        WITH
            dev_email_addresses AS (SELECT DISTINCT (email)
                                    FROM spree_orders
                                    WHERE email IN
                                          ('elton.stewart+admin@gmail.com',
                                           'tobyh@fameandpartners.com',
                                           'ilnur.yakupov@gmail.com',
                                           'malleus.petrov@gmail.com',
                                           'ts-sid.vamshi@linkshare.com',
                                           'nycorby@gmail.com')
                                          OR email ilike '%@fameandpartners.com'
          ),
            all_complete_orders AS (SELECT
                                      id,
                                      number,
                                      total,
                                      email,
                                      completed_at :: DATE AS order_date
                                    FROM spree_orders
                                    WHERE completed_at IS NOT NULL
                                    AND email NOT IN (SELECT email FROM dev_email_addresses)
          ),
            order_counts AS (SELECT
                               email,
                               count(*) as orders_per_user,
                               sum(total) as total_for_user,
                               min(order_date) as first_order,
                               max(order_date) as last_order
                             FROM all_complete_orders
                             GROUP BY email
                             ORDER BY orders_per_user DESC)

        select * from order_counts where orders_per_user > 1;
      SQL
    end
  end
end
