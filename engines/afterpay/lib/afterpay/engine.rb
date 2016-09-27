module Afterpay
  class Engine < ::Rails::Engine
    require 'afterpay/routing'

    isolate_namespace Afterpay
  end
end
