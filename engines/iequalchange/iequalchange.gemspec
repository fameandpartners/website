$:.push File.expand_path('../lib', __FILE__)
require 'iequalchange/version'

Gem::Specification.new do |spec|
  spec.name          = 'iequalchange'
  spec.version       = Iequalchange::VERSION
  spec.authors       = ['Fame & Partners Dev Team']
  spec.email         = ['dev@fameandpartners.com']

  spec.summary       = %q{I=C Plugin}
  spec.description   = %q{I Equal Change donation plugin to hook in to the sales process.}
  spec.homepage      = 'https://github.com/fameandpartners/website/tree/master/engines/iequalchange'

  spec.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  spec.test_files = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'rails'
  spec.add_dependency 'spree'
end
