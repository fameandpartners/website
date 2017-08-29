namespace :data do
  desc 'Remove pids from revolution pages that are dead'
  task :clean_pids => :environment do
    Revolution::Page.all.each do |page|
      if (pcids = page.get(:pids))
        #grab all the pids which also contain color, then strip down to just the id
        pcids = pcids.strip.split(',')

        #verify the id, if it's a goner wipe it
        verified_pcids = []
        pcids.each do |pcid|
          pid = pcid.strip.split('-', 2)[0]
          if !Spree::Product.where(id: pid)&.first&.hidden
            verified_pcids << pcid
          end
        end

        page.variables[:pids] = verified_pcids.join(',')
        page.save
      end
    end
  end
end
