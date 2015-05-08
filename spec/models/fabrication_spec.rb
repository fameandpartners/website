require 'spec_helper'

RSpec.describe Fabrication, :type => :model do

  it 'has known states' do
    expect(Fabrication::STATES).to eq({
                                        'purchase_order_placed'      => 'PO Placed',
                                        'purchase_order_confirmed'   => 'PO Assigned',
                                        'fabric_assigned'            => 'Fabric Assigned',
                                        'style_cut'                  => 'Style Cutting',
                                        'make'                       => 'Making',
                                        'qc'                         => 'QC',
                                        'shipped'                    => 'Shipped',
                                        'customer_feedback_required' => 'Customer Feedback'
      })
  end

  it { is_expected.to validate_presence_of :line_item_id }
end
