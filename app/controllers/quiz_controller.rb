class QuizController < ApplicationController
  layout 'redesign/application'

  respond_to :html, :js

  # questions#index
  def show
    title('Style Quiz - Dress Recommendations Based on Your Style Profile', default_seo_title)
    description('Not sure to go boho, glam, edgy, classic, or girly? Fame and Partners\' style quiz can help identify your style profile and recommend that perfect dress.')

    @quiz = Quiz.active
    @questions_by_steps = @quiz.questions.includes(:answers).order('position ASC').group_by(&:step)
  end

  # answers#create
  def update
    quiz = Quiz.last
    question_ids = params[:quiz][:questions].keys

    unless quiz.questions.find(question_ids).size.eql?(quiz.questions.size)
      redirect_to style_quiz_path and return
    end

    # because Rails are stupid & try to use invalid foreign key at Spree::User#build_style_profile
    style_profile = UserStyleProfile.new
    style_profile.user = current_spree_user

    basic_styles = UserStyleProfile::BASIC_STYLES

    taxons = []

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
        redirect_to style_quiz_path and return
      end

      answers = question.answers.where(:code => answer_codes)

      unless answers.present?
        redirect_to style_quiz_path and return
      end

      style_profile.serialized_answers[question.id] = answers.map(&:id)

      taxons += answers.map(&:taxons).flatten

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

    if style_profile.user
      track_user_email(style_profile.user.email)
    else
      track_user_email(params.try(:[], :quiz).try(:[], :user).try(:[], :email))
    end

    if taxons.present?
      taxons.group_by(&:id).each do |id, group|
        style_profile.user_style_profile_taxons.create do |object|
          object.taxon = group.first
          object.capacity = group.size
        end
      end
    end

    if current_spree_user.present?
      StyleQuizCompletedEmailWorker.perform_async(style_profile.user.id, current_site_version.id)
    else
      session[:style_profile_access_token]  = style_profile.token
      session[:style_profile_id]            = style_profile.id
    end

    respond_with({}) do |format|
      format.html { redirect_to(after_quiz_redirect_url) }
      format.js   { render 'quiz/thanks' }
    end
  end

  def after_quiz_redirect_url
    "#{ style_profile_url }?pc=Zm9ybWFsMjU=&amp;h=SEVZLCBIRVJFJ1MgJDIwIEZPUiBZT1UgVE8gU1BFTkQgT04gVEhFIFBFUkZFQ1QgRFJFU1Mh&amp;m=IFVTRTogPHN0cm9uZz5HVVJMUVVJWjwvc3Ryb25nPiBBVCBDSEVDS09VVA==&amp;t=5&amp;s=Z3VybF9jb21fbW9kYWw=&amp;"
  end
  helper_method :after_quiz_redirect_url

  private

  def track_user_email(email)
    return unless email
    Marketing::CustomerIOEventTracker.new.identify_user_by_email(email, current_site_version)
  end
end
