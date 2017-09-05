namespace :data do
  desc 'Grab data for chargeback'
  task :get_chargeback, [:order_number] => [:environment] do |t, args|
    stuffs = []

    # grab
    stuffs << (ord = Spree::Order.find_by_order_number[args[:order_number]])
    stuffs << ord.user
    stuffs << ord.bill_address
    stuffs << ord.payments.first
    stuffs << ord.payments.first.source

    p stuffs
  end

end
