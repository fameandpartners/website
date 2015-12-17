require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Event, type: :presenter do
        subject(:presenter) { described_class.new(event: :anything) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns a hash with the event name' do
            expect(subject.body).to eq({ name: :anything })
          end
        end
      end
    end
  end
end
