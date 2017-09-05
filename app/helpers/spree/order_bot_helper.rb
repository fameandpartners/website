module Spree
  module OrderBotHelper
    require 'json'
    require 'rest-client'

    def client
      OrderBot::OrderBotClient.new('apitestfp@test.com', 'Testing2000')
    end

    def create_new_order_by_factory(order)
      factory_line_items = separate_line_items_by_factory(order.line_items)
      factory_line_items.each_key { |key| create_new_order(order, factory_line_items[key])}
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

      #order_bot_product_id = 2882372
      guide_id = line_item.currency.downcase == 'usd' ? '897' : '1917'
      client.create_new_order_guide(guide_id, order_bot_product_id, line_item.price)
      generate_tags_for_line_item(line_item, order_bot_product_id)
    end

    def generate_tags_for_line_item(line_item, order_bot_product_id)
      line_item.personalization.options_hash.each_pair do |key, value| #size and color
        unless value.nil?
          tag = get_or_create_tag(key, value)
          client.link_product_to_tag(order_bot_product_id, tag['tag_id'])
        end
      end
      
      line_item.personalization.customization_values.each do |customization| #customizations
        tag = get_or_create_tag(customization.customisation_type, customization.presentation)
        client.link_product_to_tag(order_bot_product_id, tag['tag_id'])
      end
      
      tag = get_or_create_tag('height', "#{line_item.personalization.height}") #height
      client.link_product_to_tag(order_bot_product_id, tag['tag_id'])

      tag = get_or_create_tag('style number', GlobalSku.find_by_product_id(line_item.product.id).style_number) #style number
      client.link_product_to_tag(order_bot_product_id, tag['tag_id'])

    end

    def get_group_id_by_product(product)
      client.get_group_id_by_product(product)
    end

    def get_measurement_type_id_by_name(name)
      client.get_measurement_type_id_by_name(name)
    end

    def get_or_create_tag(group_name, tag_name)
      group = get_or_create_tag_group(group_name)
      tags = client.get_tag_by_name(tag_name)
      tag = tags.select {|t| t['group'] == group['tag_group_name']}
      if tag.empty? || tag.first['group'] != group['tag_group_name'] #create tag or link tag to group   
        tag = client.create_new_tag({'group_id' => group['tag_group_id'], 'name' =>tag_name})
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