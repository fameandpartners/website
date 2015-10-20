require 'spec_helper'


module Marketing
  describe CustomerIOEventTracker do

    let(:site_version) { instance_spy('SiteVersion', code: 'uk') }
    let(:dummy_client) { instance_spy('Customerio::Client') }
    let(:email)        { 'penny-example@gmail.com' }
    let(:user) do
      instance_spy('Spree::User',
                   id:         999,
                   email:      email,
                   created_at: 1_437_746_159,
                   first_name: 'Penny',
                   last_name:  'Exemplar')
    end

    subject(:tracker) { described_class.new }

    before do
      allow(tracker).to receive(:client).and_return(dummy_client)
    end

    describe 'delegates to the customerio client' do
      it 'for #identify_user' do
        expect(dummy_client)
          .to receive(:identify)
                .with(
                  id:           999,
                  email:        'penny-example@gmail.com',
                  created_at:   1_437_746_159,
                  first_name:   'Penny',
                  last_name:    'Exemplar',
                  site_version: 'uk'
                )

        tracker.identify_user(user, site_version)
      end

      it 'for #track' do
        expect(dummy_client)
          .to receive(:track)
                .with(
                  999,
                  'awesome_event',
                  {custom: 'event_data'}
                )

        tracker.track(user, 'awesome_event', {custom: 'event_data'})
      end

      it 'for #delete_user' do
        expect(dummy_client)
          .to receive(:delete)
                .with(999)

        tracker.delete_user(user)
      end
    end

    describe 'sanitising inputs' do
      let(:bad_email)   { ' safe-email@example.com ' }
      let(:clean_email) { 'safe-email@example.com' }
      let(:email)     { bad_email }

      it 'for #identify_user' do
        expect(dummy_client)
          .to receive(:identify)
                .with(
                  id:           999,
                  email:        clean_email,
                  created_at:   1_437_746_159,
                  first_name:   'Penny',
                  last_name:    'Exemplar',
                  site_version: 'uk'
                )

        tracker.identify_user(user, site_version)
      end

      it 'for #identify_user_by_email' do
        expect(dummy_client)
          .to receive(:identify)
                .with(
                  id:           clean_email,
                  email:        clean_email,
                  site_version: 'uk'
                )

        tracker.identify_user_by_email(bad_email, site_version)
      end

    end
  end
end
