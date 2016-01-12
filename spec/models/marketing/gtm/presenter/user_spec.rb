require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe User, type: :presenter do
        let(:user) { build_stubbed(:spree_user, first_name: 'Loroteiro', last_name: 'Silvestre', email: 'loroteiro@silvestre.com') }
        let(:request_ip) { '179.218.87.233' }

        subject(:presenter) { described_class.new(spree_user: user, request_ip: request_ip) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          context 'given a spree user and his/her IP' do
            context 'user is not logged in' do
              subject(:presenter) { described_class.new(spree_user: nil, request_ip: request_ip) }

              it 'returns hash with unknown user info' do
                expect(subject.body).to eq({
                                               name:     'unknown',
                                               email:    'unknown',
                                               facebook: false,
                                               gender:   'unknown',
                                               loggedIn: false,
                                               country:  'Brazil',
                                               ip: '179.218.87.233'
                                           })
              end
            end

            context 'user is logged in' do
              it 'returns hash with user info' do
                expect(subject.body).to eq({
                                               name:     'Loroteiro Silvestre',
                                               email:    'loroteiro@silvestre.com',
                                               facebook: false,
                                               gender:   'unknown',
                                               loggedIn: true,
                                               country:  'Brazil',
                                               ip: '179.218.87.233'
                                           })
              end

              context 'user comes from facebook' do
                before(:each) { user.facebook_data_value[:gender] = 'male' }

                it 'returns hash with user gender and a truthy facebook key' do
                  expect(subject.body).to eq({
                                                 name:     'Loroteiro Silvestre',
                                                 gender:   'male',
                                                 email:    'loroteiro@silvestre.com',
                                                 loggedIn: true,
                                                 facebook: true,
                                                 country:  'Brazil',
                                                 ip: '179.218.87.233'
                                             })
                end
              end
            end
          end
        end
      end
    end
  end
end
