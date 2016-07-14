require 'spec_helper'

RSpec.describe Quiz, type: :model do
  context "Quiz" do
    let!(:style_quiz)   { create(:style_quiz) }
    let!(:wedding_quiz) { create(:wedding_quiz) }
    let(:quiz)          { class_double('Quiz') }

    context "::style_quiz" do
      it("returns style_quiz") do
        expect(quiz).to receive(:style_quiz).and_return(style_quiz)
        quiz.style_quiz
      end
    end

    context "::wedding_quiz" do
      it("returns wedding_quiz") do
        expect(quiz).to receive(:wedding_quiz).and_return(wedding_quiz)
        quiz.wedding_quiz
      end
    end
  end
end
