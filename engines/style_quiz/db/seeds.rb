module StyleQuiz
  class Seed
    def populate(options = {})
      puts "StyleQuiz::Seed. populate"
      #populate_tags
      #populate_questions
      populate_answers
    end

    def populate_tags
      ['color.yml', 'pattern.yml', 'fabric.yml', 'style.yml', 'feature.yml', 'trends.yml'].each do |tags_file|
        path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', tags_file)
        YAML.load(File.read(path)).each do |tag_data|
          ::StyleQuiz::Tag.where(tag_data).first_or_create
        end
      end
    end

    def populate_questions
      path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', 'questions.yml')
      YAML.load(File.read(path)).each_with_index do |question_data, index|
        StyleQuiz::Question.where(code: question_data[:code]).first_or_create do |q|
          q.assign_attributes(question_data, without_protection: true)
          q.position = index
        end
      end
    end

    def populate_answers
      StyleQuiz::Question.all.each do |question|
        path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', "#{ question.code }-question-answers.yml")
        if FileTest.exists?(path)
          YAML.load(File.read(path)).each_with_index do |answer_data, index|
            question.answers.where(value: answer_data[:value].to_s).first_or_create do |answer|
              tag_names = answer_data.delete(:tags)
              answer.assign_attributes(answer_data, without_protection: true)
              answer.position = index
              answer.tags = get_tag_ids(tag_names)
              answer.active = true
            end
          end
        else
          puts "answers for question #{ question.name } not found or not required"
        end
      end
    end

    def convert_tag_name_to_key(name)
      name.downcase.parameterize
    end

    def tags_map
      @tags_map ||= begin
        result = {}
        StyleQuiz::Tag.all.each do |tag|
          result[convert_tag_name_to_key(tag.name)] = tag.id
        end
      end
    end

    def get_tag_ids(tag_names = nil)
      return [] if tag_names.blank?

      tag_names.map do |name|
        tags_map[convert_tag_name_to_key(name)]
      end
    end
  end
end
