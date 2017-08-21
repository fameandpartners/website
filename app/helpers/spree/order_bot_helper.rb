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

    def create_order(line_item)

    end

    def generate_order_object(line_item)

    end

    def get_measurement_type_id_by_name(measurement_name)
      res = make_get_request('admin/units_of_measurement_types.json/')
      res_json = JSON.parse(res.body)
      res_json.select {|measurement| measurement['name'] == measurement_name}.first['units_of_measure_id']
      #add logic if above returns nil
    end

    def get_group_id_by_product(product)
      19990
      # res = make_get_request('admin/product_structure.json/')
      # res_json = JSON.parse(res.body)
      # taxon_names = product.taxons.map{ |taxon| taxon.name}
      # groups = res_json.first['product_classes'].first['categories'].select {
      #     |category| category['groups'].any? {
      #         |z| taxon_names.include?(z['group_name'])
      #       }
      #   }.map{
      #     |z| z['groups']
      #   }.first 
      # groups.select{|group| group['group_name'] == 'Playsuit'}.first['group_id']
      #add logic if above returns nil
    end

    def create_new_order_guide(product_id, price)

    end

    def create_new_product(line_item)
      product = OrderBot::Product.new(line_item)
      res = make_post_request('admin/products.json/', [product]) #needs to take in an array of objects for api
      order_bot_product = JSON.parse(res.body)
      order_bot_product_id = order_bot_product['orderbot_product_id']
      create_new_order_guide(order_bot_product_id, product.price)
    end

    def create_new_order(order)
      bot_order = OrderBot::Order.new(order, order.line_items)
      res = make_post_request('admin/orders.json/', [bot_order])
      rel = res
    end

    def get_group_id_by_group_name(group_name)
      res = make_get_request('admin/product_structure.json/')
      res_json = JSON.parse(res.body)
      res_json.first['product_classes'].first['categories'].select {|category| category['groups'].any? {|z| z['group_name'] == group_name}} #product.taxons.map{ |taxon| taxon.name}.includes? z['group_name']
      #add logic if above returns nil
    end

    def make_get_request( url, params = {}) 
      RestClient::Request.execute(method: :get, url: "http://api.orderbot.com/#{url}", user: 'apitestfp@test.com', password: 'Testing2000', log: Logger.new(STDERR))
    end

    def make_post_request(url, request_object)
      RestClient::Request.execute(method: :post, url: "http://api.orderbot.com/#{url}", payload: request_object.to_json, headers: {content_type: :json}, user: 'apitestfp@test.com', password: 'Testing2000', log: Logger.new(STDERR))
    end

  end
end