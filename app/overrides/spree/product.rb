Deface::Override.new(:virtual_path => "spree/admin/shared/_product_tabs",
                     :name => "add_product_style_profile_tab",
                     :insert_bottom => "[data-hook='admin_product_tabs']",
                     :text => %q{<li<%== ' class="active"' if current == 'Style Profile' %>>
                                   <%= link_to_with_icon 'icon-th-large', t(:style_profile),  edit_admin_product_style_profile_url(@product) %>
                                 </li>},
                     :disabled => false)
