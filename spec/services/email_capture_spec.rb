require 'spec_helper'

describe EmailCapture do
  let(:user) { build(:spree_user) }
  let(:mailchimp) { EmailCapture.new({service: 'mailchimp'}) }

  it { expect(EmailCapture.new({service: 'mailchimp'}).service).to eq 'mailchimp' }
  it { expect(EmailCapture.new({service: 'Mailchimp'}).service).to eq 'mailchimp' }

  describe 'call .capture' do
    context 'when service is mailchimp' do

      it 'something' do
        # p mailchimp.service
      end
    end
  end

  describe 'call .email_changed?' do
    it { expect(mailchimp.email_changed?(user)).to be_falsey }
    it 'returns true when email was changed' do
      user.save #Can I emulate this without writing to the database?
      user.email = 'change@test.com'
      expect(mailchimp.email_changed?(user)).to be_truthy
    end
    it 'returns false when a new contact is passed' do
      contact = Contact.new(email: 'test@test.com')
      expect(mailchimp.email_changed?(contact)).to be_falsey
    end
  end

  describe 'call .retrieve_first_name' do
    it { expect(mailchimp.retrieve_first_name(user)).to eq user.first_name }
    it 'returns first name when a contact is passed' do
      contact = Contact.new(email: 'test@test.com', first_name: "First")
      expect(mailchimp.retrieve_first_name(contact)).to eq contact.first_name
    end
    it 'returns nil when a OpenStruct is passed' do
      os = OpenStruct.new(email: 'test@test.com')
      expect(mailchimp.retrieve_first_name(os)).to be_nil
    end
  end

  describe 'call .retrieve_last_name' do
    it { expect(mailchimp.retrieve_last_name(user)).to eq user.last_name }
    it 'returns last name when a contact is passed' do
      contact = Contact.new(email: 'test@test.com', last_name: "Last")
      expect(mailchimp.retrieve_last_name(contact)).to eq contact.last_name
    end
    it 'returns nil when a OpenStruct is passed' do
      os = OpenStruct.new(email: 'test@test.com')
      expect(mailchimp.retrieve_last_name(os)).to be_nil
    end
  end

  describe 'call .activerecord?' do
    it { expect(mailchimp.activerecord?(user)).to be_truthy }
    it { expect(mailchimp.activerecord?(Contact.new(email: 'test@test.com', last_name: "Last"))).to be_falsey }
    it { expect(mailchimp.activerecord?(OpenStruct.new(email: 'test@test.com'))).to be_falsey }
  end

  describe 'call .set_newsletter' do
    let(:subscriber) { [] }

    it 'returns no when no newsletter is set and user is passed' do
      expect(mailchimp.set_newsletter(user, subscriber)).to eq 'no'
    end
    it 'returns yes when newsletter is set and user is passed' do
      user.newsletter = true
      expect(mailchimp.set_newsletter(user, subscriber)).to eq 'yes'
    end
    it 'returns no when no newsletter is set and a non-activerecord object is passed' do
      expect(mailchimp.set_newsletter(Contact.new(email: 'test@test.com'), subscriber)).to eq 'no'
    end
  end

  describe 'call .set_merge' do
    let(:subscriber) { [] }
    context 'when passed the user' do
      before  {user.current_sign_in_ip = "101.0.79.50" }
      it { expect(mailchimp.set_merge(user, subscriber).class.to_s).to eq 'Hash' }
      it { expect(mailchimp.set_merge(user, subscriber)[:fname]).to eq user.first_name }
      it { expect(mailchimp.set_merge(user, subscriber)[:lname]).to eq user.last_name }
      it { expect(mailchimp.set_merge(user, subscriber)[:ip_address]).to eq user.current_sign_in_ip }
      it { expect(mailchimp.set_merge(user, subscriber)[:country]).to be }
      it { expect(mailchimp.set_merge(user, subscriber)[:n_letter]).to eq 'no' }
    end

    context 'when passed a contact' do
      let(:contact) { Contact.new(email: 'test@test.com', first_name: "First", last_name: "Last" ) }
      it { expect(mailchimp.set_merge(contact, subscriber)[:fname]).to eq contact.first_name }
      it { expect(mailchimp.set_merge(contact, subscriber)[:lname]).to eq contact.last_name }
      it { expect(mailchimp.set_merge(contact, subscriber)[:n_letter]).to eq 'no' }
    end

    context 'when passed a OpenStruct' do
      let(:os) { OpenStruct.new(email: 'test@test.com', current_sign_in_ip: "101.0.79.50") }
      it { expect(mailchimp.set_merge(os, subscriber)[:ip_address]).to eq os.current_sign_in_ip }
      it { expect(mailchimp.set_merge(os, subscriber)[:country]).to be }
      it { expect(mailchimp.set_merge(os, subscriber)[:n_letter]).to eq 'no' }
    end

  end

end

