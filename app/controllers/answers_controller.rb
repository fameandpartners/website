class AnswersController < ApplicationController
  before_filter :authenticate_spree_user!

  include SslRequirement
  ssl_allowed

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

      basic_styles = UserStyleProfile::BASIC_STYLES

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

            if basic_styles.include?(attribute)
              points = points / quiz.questions.select(&:pointable?).count
            end

            style_profile.send("#{attribute}=", style_profile.send(attribute) + points)
          end
        end

        factor = style_profile.attributes.slice(*basic_styles).values.sum / 10.0

        total = 0

        basic_styles.each do |attribute|
          points = (style_profile.send(attribute) / factor).round(2)

          if total >= 10
            points = 0
          elsif (points + total) > 10
            points = (10.0 - total).round(2)
          elsif basic_styles.last.eql?(attribute) && (total + points) < 10
            points = (10.0 - total).round(2)
          end

          style_profile.send("#{attribute}=", points)
          total = (total + points).round(2)
        end

        style_profile.serialized_answers = session['quiz']['answers']

        style_profile.save

        render 'quizzes/thanks'
        Spree::UserMailer.style_profile_created(style_profile.user).deliver
      else
        redirect_to quiz_path
      end
    else
      redirect_to quiz_path
    end
  end
end
