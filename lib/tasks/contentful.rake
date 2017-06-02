namespace :data do
  desc 'Populate contentful routes'
  task :contentful_routes => :environment do
  	c = ContentfulRoute.new
  	c.route_name = '/contentful-test-page'
  	c.template_name = 'contentful/application'
  	c.layout = 'layouts/contentful/main'
  	c.save

  	e = ContentfulRoute.new
  	e.route_name = '/does-not-matter'
  	e.template_name = 'contentful/application'
  	e.layout = 'layouts/contentful/main'
  	e.save

  	e = ContentfulRoute.new
  	e.route_name = '/the-path-to-this-new-LP'
  	e.template_name = 'contentful/application'
  	e.layout = 'layouts/contentful/main'
  	e.save
  	
  end
end