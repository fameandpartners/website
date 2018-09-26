namespace :reports do
  desc 'Report order bot issues'
  task :order_bot_failure_check => :environment do
    next if Features.inactive?(:orderbot)
    orders = Spree::Order.where("completed_at >= ? AND orderbot_synced is null AND state = 'complete'", 7.hours.ago)
    unless orders.empty?
      order_numbers = orders.map {|x| x.number}

      order_numbers_str = order_numbers.join(',')

      OrderBotStatusMailer.email(order_numbers_str).deliver
    end
  end
end
