require 'spec_helper'

describe WeddingAtelier::Event do

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
        event = WeddingAtelier::Event.new(attrs)
        expect(event.save).to be_falsey
        expect(event.errors[:date]).to match_array ["can't be blank"]
        expect(event.date).to be_nil
      end
    end

  end
end
