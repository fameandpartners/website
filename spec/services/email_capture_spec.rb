require 'spec_helper'

describe EmailCapture, :vcr do
  let(:user) { build(:spree_user, first_name: 'John', last_name: 'Doe', email: 'some.user5@gmail.com') }

  let(:email_capture) { EmailCapture.new({ service: :mailchimp },
                                       email:              user.email,
                                       first_name:         user.first_name,
                                       last_name:          user.last_name,
                                       current_sign_in_ip: "101.0.79.50",
                                       landing_page:       "/dresses/formal",
                                       utm_params:         '',
                                       site_version:       'US',
                                       form_name:          'contact') }

  it { expect(email_capture.service).to eq :mailchimp }
  it { expect(EmailCapture.new({service: 'Mailchimp'},
                               email:              user.email,
                               first_name:         user.first_name,
                               last_name:          user.last_name,
                               current_sign_in_ip: "101.0.79.50",
                               landing_page:       "/dresses/formal",
                               utm_params:         '',
                               site_version:       'US',
                               form_name:          'contact').service).to_not eq :mailchimp }

  describe '#email_changed?' do
    it { expect(email_capture.email_changed?).to be_falsey }
    it 'returns true when email was changed' do
      email_capture = EmailCapture.new({ service: :mailchimp },
                                         email:              user.email,
                                         previous_email: 'email@changes.com',
                                         first_name:         user.first_name,
                                         last_name:          user.last_name,
                                         current_sign_in_ip: "101.0.79.50",
                                         landing_page:       "/dresses/formal",
                                         utm_params:         '',
                                         site_version:       'US',
                                         form_name:          'contact')
      expect(email_capture.email_changed?).to be_truthy
    end
  end

  describe '#retrieve_first_name' do
    it { expect(email_capture.retrieve_first_name).to eq user.first_name }
    it 'returns nil when an empty first name is passed' do
      email_capture = EmailCapture.new({ service: :mailchimp },
                                   email:              user.email,
                                   previous_email: 'email@changes.com',
                                   last_name:          user.last_name,
                                   current_sign_in_ip: "101.0.79.50",
                                   landing_page:       "/dresses/formal",
                                   utm_params:         '',
                                   site_version:       'US',
                                   form_name:          'contact')
      expect(email_capture.retrieve_first_name).to be_nil
    end
  end

  describe '#retrieve_last_name' do
    it { expect(email_capture.retrieve_last_name).to eq user.last_name }
    it 'returns nil when an empty last name is passed' do
      email_capture = EmailCapture.new({ service: :mailchimp },
                       email:              user.email,
                       first_name:         user.first_name,
                       current_sign_in_ip: "101.0.79.50",
                       landing_page:       "/dresses/formal",
                       utm_params:         '',
                       site_version:       'US',
                       form_name:          'contact')
      expect(email_capture.retrieve_last_name).to be_nil
    end
  end

  describe '#set_newsletter' do
    it 'returns no when newsletter is set false' do
      email_capture = EmailCapture.new({ service: :mailchimp },
                       email:              user.email,
                       newsletter: false,
                       first_name:         user.first_name,
                       last_name:          user.last_name,
                       current_sign_in_ip: "101.0.79.50",
                       landing_page:       "/dresses/formal",
                       utm_params:         '',
                       site_version:       'US',
                       form_name:          'contact')
      expect(email_capture.set_newsletter).to eq 'no'
    end
    it 'returns yes when newsletter is set true' do
      email_capture = EmailCapture.new({ service: :mailchimp },
                       email:              user.email,
                       first_name:         user.first_name,
                       newsletter: true,
                       last_name:          user.last_name,
                       current_sign_in_ip: "101.0.79.50",
                       landing_page:       "/dresses/formal",
                       utm_params:         '',
                       site_version:       'US',
                       form_name:          'contact')
      expect(email_capture.set_newsletter).to eq 'yes'
    end
    it 'returns nil when no newsletter is set' do
      expect(email_capture.set_newsletter).to be_nil
    end
  end

  describe '#set_merge' do
    it { expect(email_capture.set_merge.class.to_s).to eq 'Hash' }
    it { expect(email_capture.set_merge[:fname]).to eq user.first_name }
    it { expect(email_capture.set_merge[:lname]).to eq user.last_name }
    it { expect(email_capture.set_merge[:ip_address]).to eq "101.0.79.50" }
    it { expect(email_capture.set_merge[:country]).to be }
    it { expect(email_capture.set_merge[:n_letter]).to be_nil }
  end

  describe '#unsubscribe' do
    before(:each) do
      email_capture.capture
    end

    it 'unsubscribe user and check it' do
      email_capture.mailchimp.lists.unsubscribe(email_capture.set_list_id, {email: user.email}, true, false, false)
      expect(email_capture.unsubscribed?(user.email)).to be_truthy
    end

    it "check that we can't subscribe user which unsubscribed" do
      expect(email_capture.unsubscribed?(user.email)).to be_truthy
    end
  end

end

