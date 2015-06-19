module InspiniaRails
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w{ inspinia-rails.css }
      Rails.application.config.assets.precompile += %w{ inspinia-rails.js }
      Rails.application.config.assets.paths << root.join("app", "assets", "images")
    end
  end
end
