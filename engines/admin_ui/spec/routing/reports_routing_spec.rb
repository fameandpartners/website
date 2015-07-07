require 'spec_helper'

module AdminUi
  describe 'Reports Routes', type: :routing do
    routes { ::AdminUi::Engine.routes }

    it do
      expect(get: '/reports/sale_items')
        .to route_to("controller" => "admin_ui/reports/sale_items", "action" => 'show')
    end

    it do
      expect(post: '/reports/sale_items')
        .to route_to("controller" => "admin_ui/reports/sale_items", "action" => 'create')
    end
  end
end
