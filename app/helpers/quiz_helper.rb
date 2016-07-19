module QuizHelper

  def quiz_container_class
    @quiz_type == :wedding ? " wedding-quiz-container" : ""
  end

  def quiz_progress_class
    @quiz_type == :wedding ? " wedding-quiz-progress" : ""
  end

  def quiz_next_button_class
    @quiz_type == :wedding ? " wedding-quiz-next-button" : ""
  end

end