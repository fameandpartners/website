namespace :data do
  desc 'Run the batcher code'
  task batch_items: :environment do
    Batcher.check_last_n_minutes(10)
  end

  desc 'Run the batchgroomer'
  task groom_batches: :environment do
    Batcher.groom_all_batch_collections
  end

end
