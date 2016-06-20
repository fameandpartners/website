require 'spec_helper'

describe 'Route `.php` requests', type: :routing do
  let(:controller) { {controller: 'errors/invalid_format', action: 'capture_php', path: 'abc', format: 'php'} }

  it 'routes to errors/invalid_format#capture_php' do
    expect(get: '/abc.php').to route_to(controller)
    expect(post: '/abc.php').to route_to(controller)
  end

  it 'should not route' do
    expect(get: '/abc').not_to be_routable
    expect(post: '/abc').not_to be_routable
    expect(get: '/abc.js').not_to be_routable
  end
end
