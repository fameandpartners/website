require 'spec_helper'

RSpec.describe MoodboardItemCalculator do

  MoodboardItemEvent.observers.disable do
    let(:event) do
      MoodboardItemEvent.creation.create!(
             moodboard_id:           rand(10_000),
             product_id:             rand(10_000),
             product_color_value_id: rand(10_000),
             color_id:               rand(10_000),
             user_id:                rand(10_000),
             variant_id:             rand(10_000)
      )
    end
    let(:calculator)     { described_class.new(event) }
    subject(:projection) { calculator.run }

    describe 'creation' do
      it { expect(projection.moodboard_id).to           eq event.moodboard_id }
      it { expect(projection.product_id).to             eq event.product_id }
      it { expect(projection.product_color_value_id).to eq event.product_color_value_id }
      it { expect(projection.color_id).to               eq event.color_id }
      it { expect(projection.user_id).to                eq event.user_id }
      it { expect(projection.variant_id).to             eq event.variant_id }
      it { expect(projection.likes).to                  eq 0 }
      it { expect(projection.user_likes).to             eq "" }
    end
  end
end

