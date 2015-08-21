require 'spec_helper'

describe ::StyleQuiz::UserProfilesController, type: :controller do
  render_views

  describe 'GET edit' do
    it "works event without questions" do
      get :edit

      expect(response).to render_template(file: 'style_quiz/user_profiles/edit', layout: 'redesign/application')
      expect(response).to have_http_status(:ok)
    end
  end
end
