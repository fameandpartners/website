require 'spec_helper'

describe ProductStyleProfile do
  describe "#suitable_style_names" do
    let(:profile) { ProductStyleProfile.new }

    it "should return random styles if them have equal values" do
      profile.suitable_style_names.size.should eq(2)
    end

    it "should return suitable styles" do
      profile.classic = 10
      profile.girly = 2

      profile.suitable_style_names.should eq(%w{classic girly})
    end
  end
end
