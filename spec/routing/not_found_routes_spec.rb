require 'spec_helper'

describe 'Not found requests', type: :routing do
  describe 'with *.php' do
    let(:controller) { {controller: 'errors/invalid_format', action: 'capture_php', path: 'abc', format: 'php'} }

    it 'routes to errors/invalid_format#capture_php' do
      expect(get: '/abc.php').to route_to(controller)
      expect(post: '/abc.php').to route_to(controller)
    end
  end

  describe 'with any non-existent page' do
    let(:controller) { {controller: 'application', action: 'raise_routing_error', path: 'abc'} }

    it 'rotes to application#raise_routing_error' do
      expect(get: '/abc').to route_to(controller)
      expect(post: '/abc').to route_to(controller)
      expect(get: '/abc.js').to route_to(controller.merge(format: 'js'))
    end
  end

end
