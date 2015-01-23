namespace "reports" do
  desc "bridesmaid_party_user_sales"
  task bridesmaid_party_user_sales: :environment do
    load File.join(Rails.root, 'app', 'reports', 'bridesmaid_party_user_sales.rb')
    report = Reports::BridesmaidPartyUserSales.new().report

    # do all the things to show report details)
    # report.average ==
    #<OpenStruct 
    #   bridesmaids_count=2.8727810650887573
    #   bridesmaids_registered=0.0
    #   paying_for_bridesmaids=39.94082840236686
    #   bride_purchased=0.0
    #   bridesmaids_purchased=0.0
    
    puts "\nBridesmaid Party"
    print_row("Average bridesmaids count", report.average.bridesmaids_count.round(2))
    print_row("Average bridesmaids registered", report.average.bridesmaids_registered.round(2))
    print_row("Brides purchased", report.average.bride_purchased.round, "%")
    print_row("Paying for bridesmaids", report.average.paying_for_bridesmaids.round, "%")
    print_row("Bridesmaids purchased", report.average.bridesmaids_purchased.round, "%")
    puts ""
  end

  def print_row(title, value, postfix = nil)
    puts "#{ title.ljust(30) } #{ (value.to_s + postfix.to_s).rjust(5) }"
  end
end
