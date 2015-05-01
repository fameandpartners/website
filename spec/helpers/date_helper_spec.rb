require_relative '../../app/helpers/date_helper'
require 'active_support/all'

module StubLocalisationHelper
  def l(a)
    a
  end
end

describe DateHelper do
  include DateHelper

  include StubLocalisationHelper


  describe '#maybe_date' do
    it 'uses a date' do
      date_object = instance_spy('DateTime')
      maybe_date(date_object)
      expect(date_object).to have_received(:to_date)
    end

    it 'passes values for localisation' do
      # I don't know of a better way of testing that
      # the object is passed to the `l()` method.
      def l(date_object)
        date_object.been_localised
      end

      underlying_date_object = spy
      date_object = double('DateTime', to_date: underlying_date_object)

      result = maybe_date(date_object)
      expect(underlying_date_object).to have_received(:been_localised)
      expect(result).to eq underlying_date_object
    end


    context 'fallback value' do
      let(:date_object) { nil }

      it 'defaults to "-"' do
        result = maybe_date(date_object)
        expect(result).to eq '-'
      end

      it 'uses provided value' do
        fallback = double
        result = maybe_date(date_object, fallback)
        expect(result).to eq fallback
      end
    end
  end
end
