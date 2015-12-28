require "rails_helper"

RSpec.describe MoodboardCommentsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/MoodboardComments").to route_to("moodboard_comments#index")
    end

    it "routes to #new" do
      expect(:get => "/MoodboardComments/new").to route_to("moodboard_comments#new")
    end

    it "routes to #show" do
      expect(:get => "/MoodboardComments/1").to route_to("moodboard_comments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/MoodboardComments/1/edit").to route_to("moodboard_comments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/MoodboardComments").to route_to("moodboard_comments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/MoodboardComments/1").to route_to("moodboard_comments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/MoodboardComments/1").to route_to("moodboard_comments#destroy", :id => "1")
    end

  end
end
