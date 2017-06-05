namespace :data do
  desc 'Change old taxon standard delivery period.'
  task :update_standard_delivery_period => :environment do
    counter = 0
    Spree::Taxon.find_each do |taxon|
      taxon.delivery_period = '7 business days'
      taxon.save
      counter += 1
    end
    puts "Rows update: #{counter}"
  end
end
