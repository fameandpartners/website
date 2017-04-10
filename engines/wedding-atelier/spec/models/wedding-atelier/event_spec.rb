require 'spec_helper'

describe WeddingAtelier::Event do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_numericality_of(:number_of_assistants).is_greater_than_or_equal_to(0) }
  end


  describe 'parse format date before saving' do
    context 'with valid dates' do
      it 'parses the date to a correct format' do
          attrs = {
            name: 'foobar',
            number_of_assistants: 1,
            date: '10/23/1989',
            event_type: 'wedding'
          }

        event = WeddingAtelier::Event.create(attrs)
        expect(event).to be_truthy
        expect(event.date.day).to eq 23
        expect(event.date.month).to eq 10
        expect(event.date.year).to eq 1989
      end
    end

    context 'with invalid dates' do
      it 'fails due to validation errors' do
        attrs = {
          name: 'foobar',
          number_of_assistants: 1,
          date: '23/10/1989',
          event_type: 'wedding'
        }
        event = WeddingAtelier::Event.create(attrs)
        expect(event).to be_truthy
        expect(event.date.day).to eq 23
        expect(event.date.month).to eq 10
        expect(event.date.year).to eq 1989
      end
    end
  end

  describe '#assistant_permitted?' do
    let(:event){ create(:wedding_atelier_event) }
    context 'when user is in assistants list' do
      it 'is permitted' do
        user = create(:spree_user, wedding_atelier_signup_step: 'completed')
        event.assistants << user
        expect(event.assistant_permitted?(user)).to be_truthy
      end
    end

    context 'when user is not in the list but is an admin' do
      it 'is permitted' do
        user = create(:spree_user, email: 'admin@fameandpartners.com')
        expect(event.assistants).not_to include(user)
        expect(event.assistant_permitted?(user)).to be_truthy
      end
    end

    context 'when user is not in the assistants list and is not an admin' do
      it 'it is not permitted' do
        user = create(:spree_user)
        expect(event.assistants).not_to include(user)
        expect(event.assistant_permitted?(user)).to be_falsey
      end
    end
  end
end
