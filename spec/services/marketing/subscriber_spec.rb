require 'spec_helper'

describe Marketing::Subscriber do
  let(:user)        { build(:spree_user) }
  let(:user_visit)  { build(:marketing_user_visit) }

  context "#create" do
    it "raises exception if not email available" do
      expect {
        Marketing::Subscriber.new().create
      }.to raise_error(RuntimeError)
    end

    it 'schedules subscriber sync' do
      subject = Marketing::Subscriber.new(email: user.email)

      expect(CampaignMonitor).to receive(:schedule).with(:synchronize, user.email, nil, subject.send(:custom_fields))
      subject.create
    end
  end

  context "#update" do
    it "do nothing if user blank" do
      subject = Marketing::Subscriber.new(email: user.email)
      expect(subject).not_to receive(:create)
      subject.update
    end

    it "do nothing if user doesn't changed" do
      subject = Marketing::Subscriber.new(user: Spree::User.new)
      expect(subject).not_to receive(:create)
      subject.update
    end

    it "calls create if user have unsaved changes" do
      subject = Marketing::Subscriber.new(user: user)
      expect(subject).to receive(:create)
      subject.update
    end
  end

  context "#details" do
    it "returns provided promocode" do
      expect(Marketing::Subscriber.new(promocode: 'code').details['promocode']).to eq('code')
    end

    it "returns valid email" do
      expect(
        Marketing::Subscriber.new(email: user.email).details['email']
      ).to eq(user.email)

      expect(
        Marketing::Subscriber.new(user: user).details['email']
      ).to eq(user.email)

      expect(
        Marketing::Subscriber.new().details['email']
      ).to be_nil
    end

    it "returns valid ip address" do
      ip = 'test_ip_address'

      allow(UserCountryFromIP).to receive(:new).and_return(double('Country', :country_name => 'blah'))

      # by user last_sign_in_ip
      user.last_sign_in_ip = ip
      expect( Marketing::Subscriber.new(ipaddress: ip ).details['ipaddress']).to eq(ip)

      # by provided
      expect( Marketing::Subscriber.new(ipaddress: ip ).details['ipaddress']).to eq(ip)

      # nil
      expect( Marketing::Subscriber.new(email: user.email).details['ipaddress']).to be_nil
    end

    it "returns valid country name" do

      expect(
        Marketing::Subscriber.new(ipaddress: '46.191.225.134').details['country']
      ).to eq('Russian Federation')

      expect(
        Marketing::Subscriber.new(ipaddress: '70.209.137.95').details['country']
      ).to eq('United States')

      expect(
        Marketing::Subscriber.new(ipaddress: 'invalid ip').details['country']
      ).to be_nil
    end

    it "returns valid referrer" do
      expect(Marketing::Subscriber.new.details['referrer']).to be_nil

      subject = Marketing::Subscriber.new
      subject.stub(:marketing_user_visit){ user_visit }

      expect(subject.details['source']).to eq(user_visit.referrer)
    end

    it "returns valid campaign" do
      expect(Marketing::Subscriber.new.details['campaign']).to be_nil
      expect(Marketing::Subscriber.new(campaign: 'test').details['campaign']).to eq('test')

      subject = Marketing::Subscriber.new
      subject.stub(:marketing_user_visit){ user_visit }
      expect(subject.details['campaign']).to eq(user_visit.utm_campaign)
    end
  end

  context "#set purchase date" do
    it "works only for existing user" do
      expect(CampaignMonitor).not_to receive(:schedule)
      Marketing::Subscriber.new.set_purchase_date
    end

    it "schedules CampaignMonitor#set_purchase_date" do
      subsriber = Marketing::Subscriber.new(user: user)
      date = double('date')

      expect(CampaignMonitor).to receive(:schedule).with(:set_purchase_date, user, date)
      subsriber.set_purchase_date(date)
    end
  end

  context "#user_changed" do
    it "true if changed valuable arguments" do
      %w{email first_name last_name current_sign_in_ip last_sign_in_ip}.each do |attr_name|
        user = Spree::User.new
        user[attr_name] = 'andytextorvalue'
        expect(
          Marketing::Subscriber.new(user: user).send(:user_changed?)
        ).to eq(true)
      end
    end

    it "false for new record" do
      expect(Marketing::Subscriber.new(user: Spree::User.new).send(:user_changed?)).to eq(false)
    end

    it "false for saved record" do
      user = create(:spree_user)
      expect(Marketing::Subscriber.new(user: create(:spree_user)).send(:user_changed?)).to eq(false)
    end
  end
end
