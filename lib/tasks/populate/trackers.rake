namespace "db" do
  namespace "populate" do
    task :trackers => :environment do
      add_tracker(Rails.env.to_s, 'UA-41247818-1')
    end

    def add_tracker(env, google_key)
      tracker = Spree::Tracker.where(environment: env, analytics_id: google_key).first_or_create
      tracker.update_attribute(:active, true)

      puts "added and activated tracker #{google_key} for #{env} environment"
    end
  end
end
