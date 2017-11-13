require 'spec_helper'


def questions_partials
  %w{outfits oscar_dresses style_words prom_makeup prom_hair prom_dresses fashionability sexiness hair_colours skin_colours body_shapes}
end

describe StyleQuizController, :type => :controller do
  render_views

  before :all do
    # populate quiz&questions
    quiz = Quiz.create(name: 'Style Quiz')
    questions_partials.each_with_index do |partial, index|
      quiz.questions.create({
        step: index.next,
        position: (1001 + index.to_i).to_s,
        partial: partial,
        text: partial
      }, { without_protection: true })
    end
  end

  describe 'GET :show' do
    before { get :show }

    it 'render something' do
      get :show
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end
  end
end
