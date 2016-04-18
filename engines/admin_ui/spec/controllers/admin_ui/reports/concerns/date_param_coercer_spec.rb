require 'rails_helper'

describe AdminUi::Reports::Concerns::DateParamCoercer, type: :controller do
  controller do
    include AdminUi::Reports::Concerns::DateParamCoercer

    def index
      @from_date = from_date
      @to_date   = to_date
      render text: 'ok'
    end
  end

  it 'parses "from" and "to" parameters into dates' do
    get :index, from: '10/10/2010', to: '11/11/2011'

    expect(assigns(:from_date)).to eq(Date.parse('10/10/2010'))
    expect(assigns(:to_date)).to eq(Date.parse('11/11/2011'))
  end

  context 'when "from" and "to" params are null' do
    it 'returns default "from" and "to" dates' do
      Timecop.freeze do
        get :index

        expect(assigns(:from_date)).to eq(6.weeks.ago)
        expect(assigns(:to_date)).to eq(Date.today)
      end
    end
  end
end
