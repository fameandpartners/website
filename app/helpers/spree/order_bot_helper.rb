module Spree
  module OrderBotHelper
    require 'json'

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
      res_json.select {|e| e['name'] == measurement_name}.first['units_of_measure_id']
      #add logic if above returns nil
    end

    def get_group_id_by_product(product)
      20340
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

     def get_group_id_by_group_name(group_name)
      res = make_get_request('admin/product_structure.json/')
      res_json = JSON.parse(res.body)
      category = res_json.first['product_classes'].first['categories'].select {|category| category['groups'].any? {|z| z['group_name'] == group_name}} #product.taxons.map{ |taxon| taxon.name}.includes? z['group_name']
      #add logic if above returns nil
    end

    def make_get_request( url, params = {}) 
      uri = URI( "http://api.orderbot.com/#{url}" )
      uri.query = URI.encode_www_form( params )
      http = Net::HTTP.new( uri.host, uri.port )
      request = Net::HTTP::Get.new( uri.request_uri )
      request.basic_auth( 'apitestfp@test.com', 'Testing2000' )
      http.request( request )
    end

    def make_post_request(url, request_object)
      uri = URI( "http://api.orderbot.com/#{url}" )
      http = Net::HTTP.new( uri.host, uri.port )
      request = Net::HTTP::Post.new( uri.request_uri )
      binding.pry
      request.basic_auth( 'apitestfp@test.com', 'Testing2000' )
      request.body = request_object.to_json
      http.request( request )
    end

  end
end