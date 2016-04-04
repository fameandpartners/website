require 'rails_helper'

describe 'Body Shape Calculator', type: :request do
  describe 'store measures' do
    context 'invalid attributes' do
      it do
        post '/body-shape-calculator/store-measures.json'

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq("{\"errors\":{\"email\":[\"is invalid\",\"can't be blank\"],\"shape\":[\"can't be blank\"],\"size\":[\"can't be blank\"],\"unit\":[\"can't be blank\"]}}")
      end
    end

    context 'valid attributes' do
      let(:valid_measure) do
        {
          bust_circumference:       '90.0',
          email:                    'something@example.com',
          hip_circumference:        '92.0',
          shape:                    'apple',
          size:                     'US 2/AU 6',
          under_bust_circumference: '92.0',
          unit:                     'cm',
          waist_circumference:      '92.0'
        }
      end

      it do
        post '/body-shape-calculator/store-measures.json', body_calculator_measure: valid_measure

        expect(response).to have_http_status(:success)
        expect(response.body).to eq("{\"saved\":\"ok\"}")
      end
    end
  end
end
