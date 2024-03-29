$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'manual_order/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'manual_order'
  s.version     = ManualOrder::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = ''
  s.summary     = 'Manual order process implementation.'
  s.description = 'Manual order process implementation.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  # Base
  s.add_dependency 'rails', '~> 3.2.22'

  # UI
  s.add_dependency 'slim'            # Version specified on main app Gemfile
  s.add_dependency 'simple_form'     # Version specified on main app Gemfile
  s.add_dependency 'reform'          # Version specified on main app Gemfile
  s.add_dependency 'kaminari'        # Version specified on main app Gemfile (spree_core)
  s.add_dependency 'chosen-rails', '~> 1.5.1'
  s.add_dependency 'datagrid', '~> 1.4.0'

end
