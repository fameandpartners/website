module OrderBot
  class OrderBotClient
    
    def initialize(user, pass)
      @user = user
      @pass = pass
    end
    def get_measurement_type_id_by_name(measurement_name)
        res = make_get_request('admin/units_of_measurement_types.json/')
        res_json = JSON.parse(res.body)
        measure = res_json.select {|measurement| measurement['name'] == measurement_name}&.first
        if measure.nil?
          return false
        else
          return measure['units_of_measure_id']
        end
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
      make_post_request('admin/order_guides.json/897', [{'product_id' => product_id, 'og_price' => price}])
    end

    def create_new_product(product)
      res = make_post_request('admin/products.json/', [product]) #needs to take in an array of objects for api
      order_bot_product = JSON.parse(res.body)
      if res.code <300 && order_bot_product.first['success']
        order_bot_product.first['orderbot_product_id']
      end
    end

    def create_new_order(order)
      make_post_request('admin/orders.json/', [order])
      #TODO: Add stuff here after hear back from Frank
    end

    def get_group_id_by_group_name(group_name)
      res = make_get_request('admin/product_structure.json/')
      res_json = JSON.parse(res.body)
      res_json.first['product_classes'].first['categories'].select {|category| category['groups'].any? {|z| z['group_name'] == group_name}} #product.taxons.map{ |taxon| taxon.name}.includes? z['group_name']
      #add logic if above returns nil
    end

    def make_get_request( url, params = {}) 
      RestClient::Request.execute(method: :get, url: "http://api.orderbot.com/#{url}", user: @user, password: @pass, log: Logger.new(STDERR))
    end

    def make_post_request(url, request_object)
      RestClient::Request.execute(method: :post, url: "http://api.orderbot.com/#{url}", payload: request_object.to_json, headers: {content_type: :json}, user: @user, password: @pass, log: Logger.new(STDERR))
    end
  end
end