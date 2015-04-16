namespace :fabrication do
  task :recalculate => :environment do
    Fabrication.all.each do |fabrication|
      FabricationCalculator.new(fabrication).run.save!
    end
  end
end

