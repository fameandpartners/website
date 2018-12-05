namespace :data do
  desc 'Cleans old and redundant information from the database'
  task :clean => :environment do
    # Spree::TokenizedPermission.delete_all("permissable_id in (select id  from spree_orders where state = 'cart' and total = 0 and updated_at < (now() - interval '2 month'))")

    sql = {
      :old_carts =>
        "FROM spree_orders WHERE completed_at IS NULL AND state = 'cart' AND created_at < '#{14.days.ago}'",
      :old_checkouts =>
        "FROM spree_orders WHERE completed_at IS NULL AND state = 'address' AND created_at < '#{60.days.ago}'",
      :orphan_line_items =>
        "FROM spree_line_items WHERE order_id IN (SELECT order_id FROM spree_line_items EXCEPT SELECT id AS order_id FROM spree_orders);",
      :orphan_line_item_personalizations =>
        "FROM line_item_personalizations WHERE line_item_id IN ( SELECT line_item_id FROM line_item_personalizations EXCEPT SELECT id AS line_item_id FROM spree_line_items)",
      :old_activities =>
        "FROM activities WHERE created_at < '#{6.months.ago}'",
      :old_permissions =>
        "FROM spree_tokenized_permissions WHERE created_at < '#{7.days.ago}'"
    }

    actions = { :count => 'SELECT count(*) ',
                :delete => 'DELETE ' }
    sql.each do |name, fragment|
      puts "--- #{name} ---"
      actions.each do |action, prefix|
        query = [prefix, fragment].join(' ')
        puts query
        result = ActiveRecord::Base.connection.execute(query)
        puts result.values.flatten if action == :count
        puts result.cmd_status if action == :delete
      end
    end
    puts 'VACUUM ANALYZE'
    ActiveRecord::Base.connection.execute('VACUUM ANALYZE')
  end
end
