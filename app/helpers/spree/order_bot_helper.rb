module Spree
  module OrderBotHelper
    require 'json'
    require 'rest-client'

    def client
      OrderBot::OrderBotClient.new(configatron.order_bot_client_user , configatron.order_bot_client_pass)
    end

    def create_new_order_by_factory(order)
      non_sale_order_line_items = order.line_items.select{|x| x.stock.nil?}

      unless non_sale_order_line_items.empty?
        factory_line_items = separate_line_items_by_factory()
        making_time_line_items = separate_line_items_by_make_time(factory_line_items)
        making_time_line_items.each_key { |key| create_new_order(order, making_time_line_items[key])}
      end
    end

    def separate_line_items_by_make_time(line_items_hash)
      h = Hash.new { |hash, key| hash[key] = []}
      line_items_hash.each_pair do |key, line_items|
        line_items.each do |line_item|
          if line_item.fast_making?
            h["#{key} #{line_item.delivery_period} fast_making"] << line_item
          elsif line_item.slow_making?
            h["#{key} #{line_item.delivery_period} slow_making"] << line_item
          else
            h["#{key} #{line_item.delivery_period} regular_making"] << line_item
          end
        end
      end
      h
    end
    
    def separate_line_items_by_factory(line_items)
      h = Hash.new { |hash, key| hash[key] = [] }
      
      line_items.each do |line_item|
        h[line_item.product.factory_id] << line_item
      end
      h
    end

    def create_new_order(order, factory_line_items)
      split_line_items = split_order(factory_line_items)
      split_line_items.each {|items| #not a traditional line_item
        items.each {|item| create_new_product_associate_order_guide(item)}
        bot_order = OrderBot::Order.new(order, items)
        client.create_new_order(bot_order)
      }
    end

    def get_or_create_product(line_item)
      spree_product = line_item.product
      product_id = client.get_product_by_name_and_sku(spree_product.name, CustomItemSku.new(line_item).call)
      if product_id.nil?
        product = OrderBot::Product.new(line_item, spree_product)
        product_id = client.create_new_product(product)
      end
    product_id
    end

    def create_new_product_associate_order_guide(line_item)

      order_bot_product_id = get_or_create_product(line_item)

      guide_id = client.get_order_guide_for_currency(line_item.currency)
      client.create_new_order_guide(guide_id, order_bot_product_id, line_item.price)
      unless line_item.product.name.downcase == 'return_insurance'
        generate_tags_for_line_item(line_item, order_bot_product_id)
      end
    end

    def generate_tags_for_line_item(line_item, order_bot_product_id)
      unless line_item.personalization.nil?
        line_item.personalization.options_hash.each_pair do |key, value| #size and color
          unless value.nil?
            tag = get_or_create_tag(key, value)
            client.link_product_to_tag(order_bot_product_id, tag['tag_id'])
          end
        end
        
        line_item.personalization.customization_values.each do |customization| #customizations
          tag = get_or_create_tag("customization", customization.presentation)
          client.link_product_to_tag(order_bot_product_id, tag['tag_id'])
        end
      
        tag = get_or_create_tag('height', "#{line_item.personalization.height}") #height
        client.link_product_to_tag(order_bot_product_id, tag['tag_id'])
      end
      
      tag = get_or_create_tag('style number', GlobalSku.find_by_product_id(line_item.product.id).style_number) #style number
      client.link_product_to_tag(order_bot_product_id, tag['tag_id'])

    end

    def get_customer_id(country_code)
      client.get_customer_id(country_code)
    end

    def get_or_create_group_id_by_product(product)
      cat_ids = get_or_create_category_id_by_product(product)
      product_structure = client.get_product_structure(product)

      groups = []

      sales_category = parse_product_structure(product.category.category, 'Sales', 'Sales', product_structure)
      sales_groups = sales_category['groups'].select {|group| group['group_name'] == product.category.subcategory}

      component_category = parse_product_structure(product.category.category, 'Component', 'Component', product_structure)
      component_groups = component_category['groups'].select {|group| group['group_name'] == product.category.subcategory}

      if sales_groups.empty?
        groups << client.create_new_product_group({'group_name' => product.category.subcategory, 'category_id' => cat_ids[0], 'group_active' => true}).first['product_group_id']
      else
        groups << sales_groups.first['group_id']
      end

      if component_groups.empty?
        groups << client.create_new_product_group({'group_name' => product.category.subcategory, 'category_id' => cat_ids[1], 'group_active' => true}).first['product_group_id']
      else
        groups << component_groups.first['group_id']
      end
      groups
    end

    def parse_product_structure(product_category, class_type_name, product_class_name, product_structure)     
      class_type = product_structure.select {|class_type| class_type['class_type_name'] == class_type_name}
      product_class = class_type.first['product_classes'].select{|product_class| product_class['product_class_name'] == product_class_name }
      category = product_class.first['categories'].select{|cat| cat['category_name'] == product_category}
      category&.first
    end

    def parse_product_class_id(structure, product_class_name)
      class_type = structure.select {|class_type| class_type['class_type_name'] == product_class_name}
      product_class = class_type.first['product_classes'].select{|product_class| product_class['product_class_name'] == product_class_name }.first
      product_class['product_class_id']
    end

    def get_or_create_category_id_by_product(product)
      category = []
      product_structure = client.get_product_structure(product.category.category)

      sales_category = parse_product_structure(product.category.category, 'Sales', 'Sales', product_structure)

      if sales_category
        category << sales_category['category_id']
      end

      component_category = parse_product_structure(product.category.category, 'Component', 'Component', product_structure)
      if component_category
        category << component_category['category_id']
      end

      if category.empty?
        category << client.create_new_category({'category_name' => product.category.category, 'product_class_id' => parse_product_class_id(product_structure, 'Sales'), 'category_active' => true}) # add to both components and Sales
        category << client.create_new_category({'category_name' => product.category.category, 'product_class_id' => parse_product_class_id(product_structure, 'Component'), 'category_active' => true})  #update product_class_id for future
      end

      category
    end

    def get_measurement_type_id_by_name(name)
      client.get_measurement_type_id_by_name(name)
    end

    def get_or_create_tag(group_name, tag_name)
      group = get_or_create_tag_group(group_name)
      tags = client.get_tag_by_name(tag_name)
      tag = tags.select {|t| t['group'] == group['tag_group_name']}
      if tag.empty? || tag.first['group'] != group['tag_group_name'] #create tag or link tag to group   
        tag = client.create_new_tag({'group_id' => group['tag_group_id'], 'name' => tag_name})
      end
      tag.first
    end

    def get_or_create_tag_group(group_name)
      group = client.get_tag_group_by_name(group_name)
      if group.nil?
        client.create_new_tag_group({'sales_channel_id' => 0, 'name' => group_name})
        group = client.get_tag_group_by_name(group_name)
      end
      group
    end

    def get_distribution_center(factory)
      distribution_center_id = client.get_distribution_center_id_by_name(factory)
      distribution_center_id
    end

     def sync_last_hours_order_updates
      orders = client.get_orders_modified_last_hours
      orders.each do |order|
        order['']
      end
    end

    def split_order(line_items)
      lol = []
      nested_items = []
      sum = 0
      line_items = line_items.sort_by {|item| item.price}
      line_items.each do |item| 
        if (sum + item.price >= 800)
          lol.push(nested_items)
          nested_items = []
          sum = 0
        end
        nested_items.push(item)
        sum += item.price
      end
      unless nested_items.empty?
        lol.push(nested_items)
      end
      lol
    end

  end
end
