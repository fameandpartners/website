# -*- encoding: utf-8 -*-
# stub: spree_promo 1.3.6.beta ruby lib

Gem::Specification.new do |s|
  s.name = "spree_promo"
  s.version = "1.3.6.beta"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David North"]
  s.date = "2016-05-13"
  s.description = "Required dependency for Spree"
  s.email = "david@spreecommerce.com"
  s.files = ["LICENSE", "app/assets", "app/assets/javascripts", "app/assets/javascripts/admin", "app/assets/javascripts/admin/product_picker.js", "app/assets/javascripts/admin/promotions.js", "app/assets/javascripts/admin/spree_promo.js", "app/assets/javascripts/admin/user_picker.js", "app/assets/javascripts/store", "app/assets/javascripts/store/spree_promo.js", "app/assets/stylesheets", "app/assets/stylesheets/admin", "app/assets/stylesheets/admin/spree_promo.css", "app/assets/stylesheets/store", "app/assets/stylesheets/store/spree_promo.css", "app/controllers", "app/controllers/spree", "app/controllers/spree/admin", "app/controllers/spree/admin/promotion_actions_controller.rb", "app/controllers/spree/admin/promotion_rules_controller.rb", "app/controllers/spree/admin/promotions_controller.rb", "app/controllers/spree/checkout_controller_decorator.rb", "app/controllers/spree/content_controller_decorator.rb", "app/controllers/spree/orders_controller_decorator.rb", "app/controllers/spree/store_controller_decorator.rb", "app/helpers", "app/helpers/spree", "app/helpers/spree/promotion_rules_helper.rb", "app/models", "app/models/spree", "app/models/spree/adjustment_decorator.rb", "app/models/spree/calculator", "app/models/spree/calculator/free_shipping.rb", "app/models/spree/calculator/percent_per_item.rb", "app/models/spree/order_decorator.rb", "app/models/spree/order_updater_decorator.rb", "app/models/spree/payment_decorator.rb", "app/models/spree/product_decorator.rb", "app/models/spree/promotion", "app/models/spree/promotion.rb", "app/models/spree/promotion/actions", "app/models/spree/promotion/actions/create_adjustment.rb", "app/models/spree/promotion/actions/create_line_items.rb", "app/models/spree/promotion/rules", "app/models/spree/promotion/rules/first_order.rb", "app/models/spree/promotion/rules/item_total.rb", "app/models/spree/promotion/rules/product.rb", "app/models/spree/promotion/rules/user.rb", "app/models/spree/promotion/rules/user_logged_in.rb", "app/models/spree/promotion_action.rb", "app/models/spree/promotion_action_line_item.rb", "app/models/spree/promotion_rule.rb", "app/overrides", "app/overrides/promo_admin_tabs.rb", "app/overrides/promo_cart_coupon_code_field.rb", "app/overrides/promo_coupon_code_field.rb", "app/overrides/promo_product_properties.rb", "app/views", "app/views/spree", "app/views/spree/admin", "app/views/spree/admin/promotion_actions", "app/views/spree/admin/promotion_actions/create.js.erb", "app/views/spree/admin/promotion_actions/destroy.js.erb", "app/views/spree/admin/promotion_rules", "app/views/spree/admin/promotion_rules/create.js.erb", "app/views/spree/admin/promotion_rules/destroy.js.erb", "app/views/spree/admin/promotions", "app/views/spree/admin/promotions/_actions.html.erb", "app/views/spree/admin/promotions/_form.html.erb", "app/views/spree/admin/promotions/_promotion_action.html.erb", "app/views/spree/admin/promotions/_promotion_rule.html.erb", "app/views/spree/admin/promotions/_rules.html.erb", "app/views/spree/admin/promotions/_tab.html.erb", "app/views/spree/admin/promotions/actions", "app/views/spree/admin/promotions/actions/_create_adjustment.html.erb", "app/views/spree/admin/promotions/actions/_create_line_items.html.erb", "app/views/spree/admin/promotions/edit.html.erb", "app/views/spree/admin/promotions/index.html.erb", "app/views/spree/admin/promotions/new.html.erb", "app/views/spree/admin/promotions/rules", "app/views/spree/admin/promotions/rules/_first_order.html.erb", "app/views/spree/admin/promotions/rules/_item_total.html.erb", "app/views/spree/admin/promotions/rules/_landing_page.html.erb", "app/views/spree/admin/promotions/rules/_product.html.erb", "app/views/spree/admin/promotions/rules/_user.html.erb", "app/views/spree/admin/promotions/rules/_user_logged_in.html.erb", "app/views/spree/checkout", "app/views/spree/checkout/_coupon_code_field.html.erb", "app/views/spree/orders", "app/views/spree/orders/_coupon_code_field.html.erb", "app/views/spree/products", "app/views/spree/products/_promotions.html.erb", "config/locales", "config/locales/en.yml", "config/routes.rb", "db/migrate", "db/migrate/20120831092359_spree_promo_one_two.rb", "lib/spree", "lib/spree/promo", "lib/spree/promo.rb", "lib/spree/promo/engine.rb", "lib/spree/promo/environment.rb", "lib/spree_promo.rb"]
  s.homepage = "http://spreecommerce.com"
  s.licenses = ["BSD-3"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = ["none"]
  s.rubygems_version = "2.4.7"
  s.summary = "Promotion functionality for use with Spree."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["= 1.3.6.beta"])
    else
      s.add_dependency(%q<spree_core>, ["= 1.3.6.beta"])
    end
  else
    s.add_dependency(%q<spree_core>, ["= 1.3.6.beta"])
  end
end
