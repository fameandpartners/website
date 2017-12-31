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

    def get_product_structure(product)
       res = make_get_request('admin/product_structure.json/')
       res_json = JSON.parse(res.body)
       res_json
    end

    def create_new_product_group(product_group)
      res = make_post_request('admin/product_groups.json/', [product_group])
      res_json = JSON.parse(res.body)
      res_json
    end

    def get_tag_by_name(name)
      res = make_get_request("admin/tags.json/?name=#{name}")
      JSON.parse(res.body)
    end

    def create_new_tag(tag)
      res = make_post_request('admin/tags.json/', [tag])
      bot_tag = JSON.parse(res.body)
      if res.code <300 && bot_tag.first['is_successful']
        bot_tag
      end
    end

    def get_tag_group_by_name(name)
      res = make_get_request('admin/taggroups.json/')
      tag_groups = JSON.parse(res.body)
      groups = tag_groups.select {|group| group['tag_group_name'] == name}
      groups&.first

    end

    def create_new_tag_group(group)
      res = make_post_request('admin/taggroups.json/', group)
      res
    end

    def link_product_to_tag(product_id, tag_id)
     res = make_post_request("admin/ProductTags.json/?tagid=#{tag_id}", {'product_ids' => [product_id]})
     res
     #handle failure TODO
    end

    def get_customer_id(country_code)
      res = make_get_request('admin/customers.json/')
      res_body = JSON.parse(res.body)
      customer = res_body.select {|x| x['country'].downcase == 'us'}.first
      if country_code.downcase == 'au'
        customer = res_body.select {|x| x['country'].downcase != 'us'}.first
      end
      customer['customer_id']
    end

    def create_new_order_guide(guide_id, product_id, price)
      make_post_request("admin/order_guides.json/#{guide_id}", [{'product_id' => product_id, 'og_price' => price}])
    end

    def get_product_by_name_and_sku(name, sku)
      res = make_get_request("admin/products.json/?product_name=#{name}")
      order_bot_products = JSON.parse(res.body)
      if res.code <300
        prod = order_bot_products.select {|product| product['sku'] == sku}&.first
        unless prod.nil?
          return prod['product_id']
        end
      end
    end

    def create_new_product(product)
      res = make_post_request('admin/products.json/', [product]) #needs to take in an array of objects for api
      order_bot_product = JSON.parse(res.body)
      if res.code <300 && order_bot_product.first['success']
        return order_bot_product.first['orderbot_product_id']
      elsif !order_bot_product.first['success'] && order_bot_product&.first['message'].include?('SKU(')
        return false
      end
    end

    def create_new_order(order)
      res = make_post_request('admin/orders.json/', [order])
      res_json = JSON.parse(res.body)
      if res_json['response_code'] == -1
        raise res #Put entire response in error message if error
      else
        res = make_put_request("admin/orders.json/#{res_json['order_process_result'].first['orderbot_order_id']}", order)
        res_json = JSON.parse(res.body)
        
        if res_json['response_code'] == -1
          raise res #Put entire response in error message if error
        end
      end
      res
    end

    def get_group_id_by_group_name(group_name)
      res = make_get_request('admin/product_structure.json/')
      res_json = JSON.parse(res.body)
      res_json.first['product_classes'].first['categories'].select {|category| category['groups'].any? {|z| z['group_name'] == group_name}} #product.taxons.map{ |taxon| taxon.name}.includes? z['group_name']
      #add logic if above returns nil
    end

    def create_new_category(category)
      res = make_post_request('admin/product_categories.json/', [category])
      res_json = JSON.parse(res.body)
      res_json.first['product_category_id']
    end

    def get_distribution_center_id_by_name(factory_name)
      res = make_get_request('admin/distribution_centers.json/')
      res_json = JSON.parse(res.body)
      factory = res_json.select {|factory| factory['distribution_center_name'].include?(factory_name)}&.first
      factory ? factory['distribution_center_id'] : nil
    end 

    def get_orders_modified_last_hour
      res = make_get_request("admin/orders.json/?last_modified_at_min=#{1.hour.ago.strftime('%Y-%m-%d')}")
      res_json = JSON.parse(res.body)
      res_json
    end

    def get_order_guide_for_currency(currency)
      res = make_get_request("admin/order_guides.json/")
      res_json = JSON.parse(res.body)
      guide = res_json.select {|order_guide| order_guide['order_guide_name'].downcase == currency.downcase}&.first

      if guide
        return guide['order_guide_id']
      end
    end

    def make_get_request( url, params = {}) 
      response = RestClient::Request.execute(method: :get, url: "https://api.orderbot.com/#{url}", user: @user, password: @pass)
      Rails.logger.info(response)
      response
    end

    def make_post_request(url, request_object)
      response = RestClient::Request.execute(method: :post, url: "https://api.orderbot.com/#{url}", payload: request_object.to_json, headers: {content_type: :json}, user: @user, password: @pass)
      Rails.logger.info(response)
      response
    end

    def make_put_request(url, request_object)
      response = RestClient::Request.execute(method: :put, url: "https://api.orderbot.com/#{url}", payload: request_object.to_json, headers: {content_type: :json}, user: @user, password: @pass)
      Rails.logger.info(response)
      response
    end
  end
end