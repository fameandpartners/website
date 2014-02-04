require 'spec_helper'

describe Style do
  describe "#get_all" do
    let(:styles) { Style.get_all }

    it "should have 5 records" do
      styles.length.should eq(5)
    end

    it "should return products styles" do
      ProductStyleProfile::BASIC_STYLES.each do |style_name|
        style = styles.find(name: style_name)
        style.should_not be_nil
      end
    end
  end
end
