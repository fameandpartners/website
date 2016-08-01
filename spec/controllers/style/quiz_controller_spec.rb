require 'spec_helper'

def questions_partials
  %w{outfits oscar_dresses style_words prom_makeup prom_hair prom_dresses fashionability sexiness hair_colours skin_colours body_shapes}
end

describe QuizController, :type => :controller do
  render_views

  before(:each) do
    # populate quiz&questions
    quiz = Quiz.create(name: 'Style Quiz')
    questions_partials.each_with_index do |partial, index|
      quiz.questions.create({
                              step:     index.next,
                              position: (1001 + index.to_i).to_s,
                              partial:  partial,
                              text:     partial
                            }, { without_protection: true })
    end
  end

  describe 'GET /style-quiz' do
    let(:quiz) { create(:quiz, :style) }

    before(:each) do
      # populate quiz&questions
      questions_partials.each_with_index do |partial, index|
        quiz.questions.create({
                                step:     index.next,
                                position: (1001 + index.to_i).to_s,
                                partial:  partial,
                                text:     partial
                              }, { without_protection: true })
      end
    end

    before { get :show_style }

    it 'render something' do
      get :show
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /wedding-quiz' do
    let(:quiz) { create(:quiz, :wedding) }

    before(:each) do
      # populate quiz&questions
      questions_partials.each_with_index do |partial, index|
        quiz.questions.create({
                                step:     index.next,
                                position: (1001 + index.to_i).to_s,
                                partial:  partial,
                                text:     partial
                              }, { without_protection: true })
      end
    end
    before { get :show_wedding }

    it 'render something' do
      get :show
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end
  end
end
