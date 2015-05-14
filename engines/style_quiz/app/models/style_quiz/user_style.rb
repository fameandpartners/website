class StyleQuiz::UserStyle
  attr_reader :code
  attr_accessor :rate

  def initialize(code:)
    @code = code
  end

  def title
    I18n.t("style.#{ code }.title", default: code)
  end

  def description
    I18n.t("style.#{code }.description", default: code)
  end

  def image
    "style_quiz/style_profile/header/#{ code }.jpg"
  end

  class << self
    def all_styles
      @all_styles ||= %w{glam edgy girly classic bohemian}.map do |code|
        StyleQuiz::UserStyle.new(code: code)
      end
    end
  end
end
