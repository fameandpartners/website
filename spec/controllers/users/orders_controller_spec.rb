require 'spec_helper'

describe Users::OrdersController, type: :controller do
  let(:user) { create(:spree_user) }
  let(:foreign_user) { create(:spree_user) }
  let(:order) { create(:spree_order, user: user) }

  describe 'GET #show' do
    context 'raises NotFound' do
      before { sign_in(foreign_user) }

      it 'when order not found' do
        expect { get :show, id: 'absent_id' }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'when order is not owned by user' do
        expect { get :show, id: order.number }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'renders order' do
      before { sign_in(order.user) }

      it 'when order is owned by user' do
        expect { get :show, id: order.number }.not_to raise_error
      end
    end
  end
end
