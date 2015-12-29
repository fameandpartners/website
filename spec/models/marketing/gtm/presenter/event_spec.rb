require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Event, type: :presenter do
        subject(:presenter) { described_class.new(event_name: :anything) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns the event name' do
            expect(subject.body).to eq(:anything)
          end
        end
      end
    end
  end
end
