module Spree
  module OrderBotHelper
    require 'json'
    require 'rest-client'

    def separate_line_items_by_factory(line_items)
      h = Hash.new { |hash, key| hash[key] = [] }
      
      line_items.each do |line_item|
        h[line_item.product.factory_id] << line_item
      end
      h
    end

    def create_new_order(order)
      line_items = split_order(order.line_items)
      line_items.each {|items| 
        bot_order = OrderBot::Order.new(order, items)
        OrderBot::OrderBotClient.create_new_order(bot_order)
      }
    end

    def create_new_product_associate_order_guide(line_item)
      product = OrderBot::Product.new(line_item)
      order_bot_product_id = OrderBot::OrderBotClient.create_new_product(product)
      OrderBot::OrderBotClient.create_new_order_guide(order_bot_product_id, product.price)
      item.personalization.options_hash.each do |key, value|
        tag_id = get_or_create_tag(key, value)
        OrderBot::OrderBotClient.link_product_to_tag(order_bot_product_id, tag_id)
      end
    end

    def get_or_create_tag(group_name, tag_name)
      tag_id = OrderBot::OrderBotClient.get_or_create_tag_group(group_name, tag_name)
      if tag_id.nil?
        group_id = get_or_create_group(group_name)
        tag_id = OrderBot::OrderBotClient.create_new_tag({'group_id' => group_id, 'name' =>tag_name}])
      end
      tag_id
    end

    def get_or_create_tag_group(group_name)
      group_id = OrderBot::OrderBotClient.get_tag_group_id_by_name(group_name)
      if tag_id.nil?
        group_id = OrderBot::OrderBotClient.create_new_tag_group({'sales_channel_id' => group_id, 'name' => group_name}])
      end
      group_id
    end

    def split_order(line_items)
      lol = []
      nested_items = []
      sum = 0
      line_items = line_items.sort_by {|item| item.price}
      line_items.each{ 
        |item| 
        if (sum + line_item.price < 800)
          nested_items.push(item)
          sum += item.price
        else
          lol.push(nested_items)
          nested_items = []
          sum = 0
        end
      }
      lol
    end

  end
end