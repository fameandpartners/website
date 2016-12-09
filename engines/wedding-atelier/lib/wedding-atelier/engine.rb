module WeddingAtelier
  class Engine < ::Rails::Engine
    require 'rolify/railtie'
    require 'active_model_serializers'
    isolate_namespace WeddingAtelier
    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    initializer :assets, :group => :all do |app|
      app.config.rspec_paths << self.root
    end

    config.to_prepare do
     Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')).each do |c|
       require_dependency(c)
     end
   end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end
  end
end
