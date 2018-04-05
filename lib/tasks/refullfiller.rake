namespace :data do
  desc 'Run the refulfiller code and also do some grooming'
  task refulfill_items: :environment do
    Refulfiller.check_last_n_minutes(25)
  end

  desc 'Mark shipped or cancelled items'
  task groom_refulfill_items: :environment do
    Refulfiller.groom_all
  end
end
