module SpreeWeddingAtelier
  class Engine < Rails::Engine
    require 'rolify/railtie'
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_wedding_atelier'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
