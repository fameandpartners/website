require 'rails_helper'

RSpec.describe "MoodboardComments/show", :type => :view do
  before(:each) do
    moodboard_comment = assign(:moodboard_comment, MoodboardComment.create!(
      :moodboard_item => nil,
      :user_id => 1,
      :comment => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
