namespace :quality do
  # thanh - is this ever run anymore?
  desc 'ensure orders have a projected delivery date'
  task :order_delivery_dates => :environment do

    puts "Setting projected_delivery_date on Orders."
    scope = Spree::Order.where(<<-SQL
      projected_delivery_date IS NULL
      AND completed_at IS NOT NULL
      AND state = 'complete'
    SQL
    )
    total = scope.count

    progressbar = ProgressBar.create(
      :total => total,
      :format => 'Order: %c/%C  |%w%i|'
    )

    Spree::Order.transaction do
      scope.find_each do |order|
        order.projected_delivery_date = Policies::OrderProjectedDeliveryDatePolicy.new(order).delivery_date
        order.save!
        progressbar.increment
      end
    end
    progressbar.finish
    puts "Done"
  end
end
