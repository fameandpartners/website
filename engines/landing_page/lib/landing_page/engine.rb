module LandingPage
  class Engine < ::Rails::Engine
    isolate_namespace LandingPage

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end

  end
end
