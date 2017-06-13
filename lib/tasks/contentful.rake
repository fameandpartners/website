namespace :data do
desc 'Populate contentful routes'
  task :contentful_routes => :environment do
  	af = ContentfulRoute.new
  	af.route_name = '/the-anti-fast-fashion-shop'
  	af.controller = 'contentful'
  	af.action = 'main'
  	af.save

  	th = ContentfulRoute.new
  	th.route_name = '/the-third-LP'
  	th.controller = 'contentful'
  	th.action = 'main'
  	th.save

  	sn = ContentfulRoute.new
  	sn.route_name = '/the-second-relative-url'
  	sn.controller = 'contentful'
  	sn.action = 'main'
  	sn.save
  end
end
