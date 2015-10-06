require 'spec_helper'
require 'reports/sale_items'

module Reports
  RSpec.describe Payments do

    let(:from_date) { Date.parse('2013-01-01') }
    let(:to_date)   { Date.tomorrow }

    subject(:report) { Payments.new(from: from_date, to: to_date) }

    describe '#new' do
      it 'requires from: & to:' do
        expect { Payments.new }.to raise_error ArgumentError
      end

      it do
        expect { Payments.new(from: from_date, to: to_date) }.not_to raise_error
      end
    end

    describe '#description' do
      it { expect(report.description).to eq 'ItemsSoldOnSale'  }
    end

    describe 'date coercion' do
      let(:date)         { Date.parse('2015-01-01') }
      let(:start_of_day) { '2015-01-01T00:00:00+00:00' }
      let(:end_of_day)   { '2015-01-01T23:59:59+00:00' }


      subject(:report) { Payments.new(from: date, to: date) }

      it { expect(report.from).to eq start_of_day }
      it { expect(report.to).to   eq end_of_day }
    end
  end
end
