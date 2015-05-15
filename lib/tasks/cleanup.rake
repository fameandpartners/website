namespace :data do
  desc 'Cleans old and redundant information from the database'
  task :clean => :environment do
    sql = [
      "DELETE FROM spree_orders WHERE completed_at IS NULL AND state = 'cart' AND created_at < '#{14.days.ago}'",
      "DELETE FROM spree_orders WHERE completed_at IS NULL AND state = 'address' AND created_at < '#{60.days.ago}'",
      "DELETE FROM spree_line_items WHERE order_id NOT IN (SELECT id FROM spree_orders)",
      "DELETE FROM line_item_personalizations WHERE line_item_id NOT IN (SELECT id FROM spree_line_items)",
      "DELETE FROM activities WHERE created_at < '#{6.months.ago}'",
      "DELETE FROM spree_tokenized_permissions WHERE created_at < '#{7.days.ago}'",
    ]
    
    sql.each do |s|
      puts s
      ActiveRecord::Base.connection.execute(s)
    end
  end
end
