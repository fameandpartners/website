require 'spec_helper'

describe '/admin/', type: :routing do
  it 'routes fabrication updates' do
    expect(:put => "/admin/fabrications/333").to route_to(
                                                   controller: 'admin/fabrications',
                                                   action:     'update',
                                                   id:         '333'
                                               )
  end
end
