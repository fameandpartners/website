# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'afterpay/sdk/merchant'

Gem::Specification.new do |spec|
  spec.name          = 'afterpay-sdk-merchant'
  spec.version       = Afterpay::SDK::Merchant::VERSION
  spec.authors       = ['Fame & Partners Dev Team']
  spec.email         = ['dev@fameandpartners.com']

  spec.summary       = %q{Afterpay Merchant SDK}
  spec.description   = %q{The Afterpay Merchant SDK provides Ruby APIs for processing payments, recurring payments, subscriptions and transactions using Afterpay's Merchant APIs.}
  spec.homepage      = 'https://github.com/fameandpartners/website/tree/master/engines/afterpay-sdk-merchant'

  spec.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  spec.test_files = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency('afterpay-sdk-core', '~> 0.0.1')
end
