module AdminUi
  class Engine < ::Rails::Engine
    isolate_namespace AdminUi
    initializer :assets, :group => :all do |app|
      app.config.assets.precompile += %w{ admin_ui.css }
      app.config.assets.precompile += %w{ admin_ui.js }
      app.config.assets.paths << root.join("app", "assets", "images")
      app.config.rspec_paths << self.root
    end

    # See
    # http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
    initializer :append_migrations do |app|
      unless app.root.to_s.match(root.to_s)
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
        if Rails.version =~ /\A4/
          Rails.logger.warn("Rails 4 changes app.config.paths to an object, use new code below; #{__FILE__}:#{__LINE__}")
          # config.paths["db/migrate"].expanded.each do |expanded_path|
          #   app.config.paths["db/migrate"] << expanded_path
          # end
        end
      end
    end
  end
end
