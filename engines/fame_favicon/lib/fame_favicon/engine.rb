module FameFavicon
  class Engine < ::Rails::Engine
    initializer 'fame_favicon.load_static_assets' do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
