$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mailchimp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mailchimp_client"
  s.version     = MailChimpClient::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Mailchimp."
  s.description = "TODO: Description of Mailchimp."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'sidekiq' # Version specified on main app Gemfile
  s.add_dependency 'gibbon', '~> 2.2.4'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
end
