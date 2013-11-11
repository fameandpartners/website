class AnswersController < ApplicationController
  before_filter :authenticate_spree_user!

  include SslRequirement
  ssl_allowed

  layout nil

  def create
    quiz = Quiz.last
    question_ids = params[:quiz][:questions].keys

    unless quiz.questions.find(question_ids).size.eql?(quiz.questions.size)
      redirect_to quiz_path and return
    end

    # because Rails are stupid & try to use invalid foreign key at Spree::User#build_style_profile
    style_profile = UserStyleProfile.new
    style_profile.user = current_spree_user

    basic_styles = UserStyleProfile::BASIC_STYLES

    params['quiz']['questions'].each do |id, attrs|
      question = quiz.questions.find(id)

      answer_codes = nil

      if question.multiple?
        if attrs[:answer].try('[]', :codes).is_a?(Array)
          answer_codes = attrs[:answer][:codes]
        end
      else
        if attrs[:answer].try('[]', :code).is_a?(String)
          answer_codes = Array.wrap(attrs[:answer][:code])
        end
      end

      unless answer_codes.present?
        redirect_to quiz_path and return
      end

      answers = question.answers.where(:code => answer_codes)

      unless answers.present?
        redirect_to quiz_path and return
      end

      style_profile.serialized_answers[question.id] = answers.map(&:id)

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

    style_profile.save


    MarketingMailer.style_quiz_completed(style_profile.user).deliver

    render 'quizzes/thanks'
  end
end
