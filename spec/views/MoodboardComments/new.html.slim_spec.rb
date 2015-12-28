require 'rails_helper'

RSpec.describe "MoodboardComments/new", :type => :view do
  before(:each) do
    assign(:moodboard_comment, MoodboardComment.new(
      :moodboard_item => nil,
      :user_id => 1,
      :comment => "MyText"
    ))
  end

  it "renders new moodboard_comment form" do
    render

    assert_select "form[action=?][method=?]", moodboard_comments_path, "post" do

      assert_select "input#moodboard_comment_moodboard_item[name=?]", "moodboard_comment[moodboard_item]"

      assert_select "input#moodboard_comment_user_id[name=?]", "moodboard_comment[user_id]"

      assert_select "textarea#moodboard_comment_comment[name=?]", "moodboard_comment[comment]"
    end
  end
end
