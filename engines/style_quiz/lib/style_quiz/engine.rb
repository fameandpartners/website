module StyleQuiz
  class Engine < ::Rails::Engine
    isolate_namespace StyleQuiz

    config.to_prepare do
      Dir.glob(::StyleQuiz::Engine.root + "app/models/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
      Dir.glob(::StyleQuiz::Engine.root + "app/services/**/*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
