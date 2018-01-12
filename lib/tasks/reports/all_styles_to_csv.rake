namespace :reports do
  task :get_all_current_styles => :environment do
    array_csv = []
    Spree::Product.where(deleted_at: nil, hidden: false).sort_by{|x| x.name}.map do |prd|
      mvar = prd.variants_including_master.find { |variant| variant.is_master }

      us_price = mvar.prices.find { |p| p.currency == 'USD' }
      if mvar && us_price && prd.factory
        array_csv << [prd.name, mvar&.sku, us_price&.display_price&.to_s, prd&.factory&.name]
      end
    end

    File.open('all_styles.csv', 'w') {|f| f.write(array_csv.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}
  end
end
