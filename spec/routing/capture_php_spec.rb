require 'spec_helper'

describe 'Capture .php requests', type: :routing do

  it 'routes to application#capture_php' do
    expect(get: '/abc.php').to route_to(controller: 'application', action: 'capture_php', path: 'abc', format: 'php')
  end

  it 'should not route' do
    expect(get: '/abc').not_to be_routable
    expect(get: '/abc.js').not_to be_routable
  end
end
