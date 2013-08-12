class AnswersController < ApplicationController
  before_filter :authenticate_spree_user!

  layout nil

  def create
    quiz = Quiz.last
    question = quiz.questions.find(params[:question_id])

    answer_codes = nil

    if question.multiple?
      if params[:answer].try('[]', :codes).is_a?(Array)
        answer_codes = params[:answer][:codes]
      end
    else
      if params[:answer].try('[]', :code).is_a?(String)
        answer_codes = Array.wrap(params[:answer][:code])
      end
    end

    if answer_codes.present?
      answers = question.answers.where(:code => answer_codes)
      answer_ids = answers.map(&:id)

      if answer_ids.all?{|id| question.answer_ids.include?(id) }
        session['quiz']['answers'][question.id] = answer_ids
        next_question = quiz.questions.where('position > ?', question.position).first

        if next_question.present?
          redirect_to quiz_question_path(next_question)
        else
          finish_quiz(quiz)
        end
      else
        redirect_to quiz_question_path(question)
      end
    else
      redirect_to quiz_question_path(question)
    end
  end

  private

  def finish_quiz(quiz)
    if session['quiz']['answers'].size.eql?(quiz.questions.size)
      # because Rails are stupid & try to use invalid foreign key at Spree::User#build_style_profile
      style_profile = UserStyleProfile.new
      style_profile.user = current_spree_user

      if session['quiz']['answers'].values.all?(&:present?)
        session['quiz']['answers'].each do |question_id, answer_ids|
          question = Question.find(question_id)
          answers = Answer.where(:id => answer_ids)

          if question.populate.present?
            if style_profile.respond_to?("#{question.populate}=")
              if question.multiple?
                style_profile.send("#{question.populate}=", answers.map(&:code))
              else
                style_profile.send("#{question.populate}=", answers.map(&:code).first)
              end
            end
          end

          UserStyleProfile::STYLE_ATTRIBUTES.each do |attribute|
            points = answers.map{|answer| answer.send(attribute) }.reduce(:+).to_f / answers.count

            if UserStyleProfile::BASIC_STYLES.include?(attribute)
              points = points / quiz.questions.select(&:pointable?).count
            end

            style_profile.send("#{attribute}=", style_profile.send(attribute) + points)
          end
        end

        style_profile.serialized_answers = session['quiz']['answers']

        style_profile.save

        render 'quizzes/thanks'
      else
        redirect_to quiz_path
      end
    else
      redirect_to quiz_path
    end
  end
end
