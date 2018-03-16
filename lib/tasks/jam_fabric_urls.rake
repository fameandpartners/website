namespace :data do
  desc 'get urls into table of pain'
  task :fabric_bla_bla => :environment do
    count = 0

    Dir.foreach('app/assets/images/fabrics/') do |fab|
      next if fab == '.' || fab == '..'
      a = fab.downcase.split('.')
      a.pop

      b = a[0].split('-')
      b.shift

      fabric = Fabric.where(name: b.join('-')).first
      if fabric
        fabric.image_url = "#{configatron.asset_host}/assets/fabrics/#{fab}"
        fabric.save
        count += 1
      else
        puts "#{fab} could not be found try again."
      end
    end

    puts "Bla bla: #{count}"

  end
end
