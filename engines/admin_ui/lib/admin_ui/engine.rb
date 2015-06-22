module AdminUi
  class Engine < ::Rails::Engine
    isolate_namespace AdminUi
    initializer :assets, :group => :all do |app|
      app.config.assets.precompile += %w{ admin_ui.css }
      app.config.assets.precompile += %w{ admin_ui.js }
      app.config.assets.paths << root.join("app", "assets", "images")
    end
  end
end
