module StyleQuiz
  class ProfilesController < ::StyleQuiz::ApplicationController
    def new
      @questions = [
        OpenStruct.new(
          name: 'signup',
          template: 'style_quiz/questions/signup',
          values: OpenStruct.new({
            fullname: current_spree_user.fullname,
            email: current_spree_user.try(:email),
            birthdate: 20.year.ago.to_date.to_s(:db)
          })
        ),
        OpenStruct.new(name: 'color-palette',       template: 'style_quiz/questions/color_palette'),
        OpenStruct.new(name: 'color-dresses',       template: 'style_quiz/questions/color_dresses'),
        OpenStruct.new(name: 'body-size-shape',     template: 'style_quiz/questions/body_size_shape'),
        OpenStruct.new(name: 'everyday-style',      template: 'style_quiz/questions/everyday_style'),
        OpenStruct.new(name: 'dream-style',         template: 'style_quiz/questions/dream_style'),
        OpenStruct.new(name: 'red-carpet-style',    template: 'style_quiz/questions/red_carpet_style'),
        OpenStruct.new(name: 'fashion-importance',  template: 'style_quiz/questions/fashion_importance'),
        OpenStruct.new(name: 'sexyness-importance', template: 'style_quiz/questions/sexyness_importance'),
        OpenStruct.new(name: 'events-form',         template: 'style_quiz/questions/events_form')
      ]
    end
  end
end
