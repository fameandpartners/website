require 'spec_helper'

describe EmailCapture do
  let(:user) { build(:spree_user) }
  let(:os) { OpenStruct.new(email:              user.email,
                            first_name:         user.first_name,
                            last_name:          user.last_name,
                            current_sign_in_ip: "101.0.79.50",
                            landing_page:       "/dresses/formal",
                            utm_params:         '',
                            site_version:       'US',
                            form_name:          'contact') }
  let(:mailchimp) { EmailCapture.new({ service: :mailchimp }) }

  it { expect(EmailCapture.new({service: :mailchimp}).service).to eq :mailchimp }
  it { expect(EmailCapture.new({service: 'Mailchimp'}).service).to_not eq :mailchimp }

  describe '#email_changed?' do
    it { expect(mailchimp.email_changed?(:os)).to be_falsey }
    it 'returns true when email was changed' do
      os.previous_email  =  'email@changes.com'
      expect(mailchimp.email_changed?(os)).to be_truthy
    end
  end

  describe '#retrieve_first_name' do
    it { expect(mailchimp.retrieve_first_name(os)).to eq user.first_name }
    it 'returns nil when an empty first name is passed' do
      os.first_name = nil
      expect(mailchimp.retrieve_first_name(os)).to be_nil
    end
  end

  describe '#retrieve_last_name' do
    it { expect(mailchimp.retrieve_last_name(os)).to eq user.last_name }
    it 'returns nil when an empty last name is passed' do
      os.last_name = nil
      expect(mailchimp.retrieve_last_name(os)).to be_nil
    end
  end

  describe '#set_newsletter' do
    it 'returns no when newsletter is set false' do
      os.newsletter = false
      expect(mailchimp.set_newsletter(os)).to eq 'no'
    end
    it 'returns yes when newsletter is set true' do
      os.newsletter = true
      expect(mailchimp.set_newsletter(os)).to eq 'yes'
    end
    it 'returns nil when no newsletter is set' do
      expect(mailchimp.set_newsletter(os)).to be_nil
    end
  end

  describe '#set_merge' do
    it { expect(mailchimp.set_merge(os).class.to_s).to eq 'Hash' }
    it { expect(mailchimp.set_merge(os)[:fname]).to eq user.first_name }
    it { expect(mailchimp.set_merge(os)[:lname]).to eq user.last_name }
    it { expect(mailchimp.set_merge(os)[:ip_address]).to eq os.current_sign_in_ip }
    it { expect(mailchimp.set_merge(os)[:country]).to be }
    it { expect(mailchimp.set_merge(os)[:n_letter]).to be_nil }
  end

end

