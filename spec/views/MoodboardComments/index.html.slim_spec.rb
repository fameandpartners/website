require 'rails_helper'

RSpec.describe "MoodboardComments/index", :type => :view do
  before(:each) do
    assign(:MoodboardComments, [
        MoodboardComment.create!(
        :moodboard_item => nil,
        :user_id => 1,
        :comment => "MyText"
      ),
        MoodboardComment.create!(
        :moodboard_item => nil,
        :user_id => 1,
        :comment => "MyText"
      )
    ])
  end

  it "renders a list of MoodboardComments" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
