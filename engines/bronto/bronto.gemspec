$:.push File.expand_path("../lib", __FILE__)

require "bronto/version"

Gem::Specification.new do |s|
  s.name        = "bronto"
  s.version     = Bronto::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = 'https://github.com/fameandpartners/website/tree/master/engines/bronto'
  s.summary     = 'Bronto Client'
  s.description = 'Bronto Client'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'sidekiq' # Version specified on main app Gemfile
  s.add_dependency 'savon', '~> 1.2.0'
end
