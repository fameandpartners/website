# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'afterpay/sdk/core/version'

Gem::Specification.new do |spec|
  spec.name          = 'afterpay-sdk-core'
  spec.version       = Afterpay::SDK::Core::VERSION
  spec.authors       = ['Fame & Partners Dev Team']
  spec.email         = ['dev@fameandpartners.com']

  spec.description   = %q{Core library for Afterpay ruby SDKs}
  spec.summary       = %q{Core library for Afterpay ruby SDKs}
  spec.homepage      = 'https://github.com/fameandpartners/website/tree/master/engines/afterpay-sdk-core'

  spec.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  spec.test_files = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency('xml-simple')
  spec.add_dependency('multi_json', '~> 1.0')
end
