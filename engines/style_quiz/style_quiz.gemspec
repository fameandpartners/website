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
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "jquery-rails"

  #s.add_development_dependency "sqlite3"
end
