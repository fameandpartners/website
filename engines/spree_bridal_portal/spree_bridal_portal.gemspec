# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_bridal_portal'
  s.version     = '0.0.1'
  s.summary     = 'Fame and Partners Bridal Portal'
  s.description = 'Bridal Portal to customize experience'
  s.required_ruby_version = '>= 1.8.7'

  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = ''

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3.4.1'
  s.add_dependency 'kaminari'        # Version specified on main app Gemfile (spree_core)
  s.add_dependency 'react-rails'
  s.add_dependency 'slim'            # Version specified on main app Gemfile
end
