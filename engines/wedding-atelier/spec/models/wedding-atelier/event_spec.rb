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
        event = WeddingAtelier::Event.create(attrs)
        expect(event).to be_truthy
        expect(event.date.day).to eq 23
        expect(event.date.month).to eq 10
        expect(event.date.year).to eq 1989
      end
    end
  end

  describe 'validates uniqueness of name' do
    context 'with different names' do
      it 'saves the event' do
        create(:wedding_atelier_event, name: 'test')
        event = build(:wedding_atelier_event, name: 'test1')
        expect(event.save).to be_truthy
      end
    end

    context 'with same names' do
      context 'when case sensitive' do
        it 'should not allow events with the same name' do
          create(:wedding_atelier_event, name: 'test')
          event = build(:wedding_atelier_event, name: 'TeSt')
          expect(event.save).to be_falsey
          expect(event.errors.messages[:name][0]).to eq 'has already been taken'
        end
      end

      context 'when all downcase letters' do
        it 'should not allow events with the same name' do
          create(:wedding_atelier_event, name: 'test')
          event = build(:wedding_atelier_event, name: 'test')
          expect(event.save).to be_falsey
          expect(event.errors.messages[:name][0]).to eq 'has already been taken'
        end
      end
    end
  end
end
