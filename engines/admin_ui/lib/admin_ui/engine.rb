module AdminUi
  class Engine < ::Rails::Engine
    isolate_namespace AdminUi
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w{ admin_ui.css }
      Rails.application.config.assets.precompile += %w{ admin_ui.js }
      Rails.application.config.assets.paths << root.join("app", "assets", "images")
    end
  end
end
