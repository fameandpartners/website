namespace :reports do
  desc 'Report order bot issues'
  task :order_bot_failure_check => :environment do
    orders = Spree::Order.where("created_at >= ? AND orderbot_synced != true AND state = 'complete'", 30.minutes.ago)
    unless orders.empty?
      order_numbers = orders.map {|x| x.number}

      order_numbers_str = order_numbers.join(',')

      OrderBotStatusMailer.email(order_numbers_str).deliver
    end
  end
end
