require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe User, type: :presenter do
        let(:user) do 
          build_stubbed(:spree_user,
            first_name: 'Loroteiro',
            last_name: 'Silvestre',
            email: 'loroteiro@silvestre.com'
          )
        end

        subject(:presenter) { described_class.new(spree_user: user) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          context 'given a spree user and his/her IP' do
            context 'user is not logged in' do
              subject(:presenter) { described_class.new(spree_user: nil) }

              it 'returns hash with unknown user info' do
                expect(subject.body).to include({
                  name:     'unknown',
                  email:    'unknown',
                  loggedIn: false,
                })
              end
            end

            context 'user is logged in' do
              it 'returns hash with user info' do
                expect(subject.body).to include({
                  name:     'Loroteiro Silvestre',
                  firstName: "Loroteiro",
                  lastName: "Silvestre",
                  email:    'loroteiro@silvestre.com',
                  loggedIn: true,
                })
              end
            end
          end
        end
      end
    end
  end
end
