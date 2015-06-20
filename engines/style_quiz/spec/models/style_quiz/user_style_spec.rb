require 'spec_helper'

describe StyleQuiz::UserStyle, :type => :model do
  context '#all styles' do
    it "have title" do
      StyleQuiz::UserStyle.all_styles.each do |style|
        expect(style.title).not_to be_blank
      end
    end

    it "have description" do
      StyleQuiz::UserStyle.all_styles.each do |style|
        expect(style.description).not_to eq(style.code) # not default
        expect(style.description).not_to be_blank
      end
    end

    it "have image" do
      StyleQuiz::UserStyle.all_styles.each do |style|
        file_path = File.join(::StyleQuiz::Engine.root, style.image)
        expect(FileTest.exists?( 
          File.join(::StyleQuiz::Engine.root, "app/assets/images", style.image)
        )).to eq(true) 
      end
    end
  end
end
