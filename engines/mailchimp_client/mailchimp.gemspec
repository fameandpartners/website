$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mailchimp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mailchimp_client"
  s.version     = MailChimpClient::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = 'https://github.com/fameandpartners/website/tree/master/engines/mailchimp_client'
  s.summary     = 'MailChimp integration using Gibbon'
  s.description = 'MailChimp integration using Gibbon'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'sidekiq' # Version specified on main app Gemfile
  s.add_dependency 'gibbon', '~> 2.2.4'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
end
