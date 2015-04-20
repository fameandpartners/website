require 'spec_helper'

describe 'Fabrication Routes', type: :routing do
  it do
    expect(:put => "/admin/line_items/333").to route_to(
                                                   controller: 'admin/fabrication',
                                                   action:     'update',
                                                   id:         '333'
                                               )
  end
end
