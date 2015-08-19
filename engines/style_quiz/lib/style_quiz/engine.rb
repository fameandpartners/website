module StyleQuiz
  class Engine < ::Rails::Engine
    isolate_namespace StyleQuiz

    config.to_prepare do
      [
        "app/models/**/*_decorator*.rb",
        "app/services/**/*.rb"
      ].each do |path|
        Dir.glob(::StyleQuiz::Engine.root + path).each{ |c| require_dependency(c) }
      end
    end
  end
end
