module InspiniaRails
  class Engine < ::Rails::Engine
    initializer :assets, :group => :all do |app|
      app.config.assets.precompile += %w{ inspinia-rails.css }
      app.config.assets.precompile += %w{ inspinia-rails.js }
      app.config.assets.paths << root.join("app", "assets", "images")
    end
  end
end
