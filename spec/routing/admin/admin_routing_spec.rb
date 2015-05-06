require 'spec_helper'

describe '/admin/', type: :routing do
  it 'routes fabrication updates' do
    expect(:put => "/admin/fabrications/333").to route_to(
                                                   controller: 'admin/fabrications',
                                                   action:     'update',
                                                   id:         '333'
                                               )
  end

  it 'sku_generations' do
    expect(
      expect(:get => "/admin/sku_generation").to route_to(
                                                     controller: 'admin/sku_generations',
                                                     action:     'show'
                                                 )

    )
  end
end
