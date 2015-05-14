$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "style_quiz/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "style_quiz"
  s.version     = StyleQuiz::VERSION
  s.authors     = ["Evgeniy Petrov"]
  s.email       = ["malleus.petrov@gmail.com"]
  s.homepage    = "http://fameandpartners.com"
  s.summary     = "Summary of StyleQuiz."
  s.description = "Description of StyleQuiz."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "jquery-rails"
  #s.add_dependency "spree", github: 'spree/spree', branch: '1-3-stable'
  s.add_dependency "pg", "~> 0.18"
  s.add_dependency "slim", "~> 3.0"
  s.add_dependency "slim-rails", "~> 3.0.1"

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
end
