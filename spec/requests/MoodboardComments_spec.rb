require 'rails_helper'

RSpec.describe "MoodboardComments", :type => :request do
  describe "GET /MoodboardComments" do
    it "works! (now write some real specs)" do
      get moodboard_comments_path
      expect(response).to have_http_status(200)
    end
  end
end
