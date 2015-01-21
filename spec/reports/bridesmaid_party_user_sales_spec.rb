require 'spec_helper'

describe Reports::BridesmaidPartyUserSales do
  context "empty data" do
    let(:report) { Reports::BridesmaidPartyUserSales.new.report }

    it "have defined fields" do
      expect(report.fields).to_not be_empty
    end
  end

  context "example #1" do
    # case:
    #   bride not purchased dress
    #   bride invited 5 users
    #   bride have no registered bridesmaids
    before :each do
      @user = create(:spree_user)
      @event = create(:completed_bridesmaid_party_event, spree_user_id: @user.id)
      @members = Array.new(5) {
        create(:bridesmaid_party_member, event_id: @event.id)
      }
      @report = Reports::BridesmaidPartyUserSales.new.report
    end

    it 'has one users row' do
      expect(@report.users).to_not be_empty
      expect(@report.users.length).to eq(1)
    end

    it 'has valid user data' do
      row = @report.users.first
      expect(row.bridesmaids_count).to eq(@event.bridesmaids_count)
      expect(row.bridesmaids_registered).to eq(0)
      expect(row.paying_for_bridesmaids).to be_true
      expect(row.bride_purchased).to        be_false
      expect(row.bridesmaids_purchased).to  be_false
    end

    it "has valid total" do
      user_row = @report.users.first
      row = @report.average

      expect(row.bridesmaids_count).to      eq(user_row.bridesmaids_count)
      expect(row.bridesmaids_registered).to eq(0)
      expect(row.paying_for_bridesmaids).to eq(100)
      expect(row.bride_purchased).to        eq(0)
      expect(row.bridesmaids_purchased).to  eq(0)
    end
  end

  context "example #2" do
    # case:
    #   bride have purchased something
    #   bride invited 5 users
    #   bride have 1 registerd follower
    before :each do
      @user  = create(:spree_user)
      @event = create(:completed_bridesmaid_party_event, spree_user_id: @user.id)
      @order = create(:spree_order, user_id: @user.id)
      @order.update_column(:state, 'complete')

      @members = Array.new(5){ create(:bridesmaid_party_member, event_id: @event.id )}
      @members.first.update_column(:spree_user_id, create(:spree_user).id)

      @report = Reports::BridesmaidPartyUserSales.new.report
    end

    it 'has one users row' do
      expect(@report.users).to_not be_empty
      expect(@report.users.length).to eq(1)
    end

    it 'has valid user data' do
      row = @report.users.first
      expect(row.bridesmaids_count).to eq(@event.bridesmaids_count)
      expect(row.bridesmaids_registered).to eq(1)
      expect(row.paying_for_bridesmaids).to be_true
      expect(row.bride_purchased).to        be_true
      expect(row.bridesmaids_purchased).to  be_false
    end

    it "has valid total" do
      user_row = @report.users.first
      row = @report.average

      expect(row.bridesmaids_count).to      eq(user_row.bridesmaids_count)
      expect(row.bridesmaids_registered).to eq(1)
      expect(row.paying_for_bridesmaids).to eq(100)
      expect(row.bride_purchased).to        eq(100)
      expect(row.bridesmaids_purchased).to  eq(0)
    end
  end
end
