module StyleQuiz
  class Seed
    def populate(options = {})
      puts "StyleQuiz::Seed. populate"
      populate_tags
      populate_questions
    end

    def populate_tags
      # colors
      ['color.yml', 'pattern.yml', 'fabric.yml', 'style.yml', 'feature.yml', 'trends.yml'].each do |tags_file|
        path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', tags_file)
        YAML.load(File.read(path)).each do |tag_data|
          ::StyleQuiz::Tag.where(tag_data).first_or_create
        end
      end
    end

    def populate_questions
    end
  end
end
