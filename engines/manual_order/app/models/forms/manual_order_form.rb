require 'reform'

module Forms
  class ManualOrderForm < ::Reform::Form

    property :currency, virtual: true
    property :style_name, virtual: true
    property :size, virtual: true
    property :height, virtual: true
    property :color, virtual: true
    property :customisations, virtual: true
    property :notes, virtual: true
    property :status, virtual: true
    property :email, virtual: true
    property :first_name, virtual: true
    property :last_name, virtual: true
    property :address1, virtual: true
    property :address2, virtual: true
    property :city, virtual: true
    property :state, virtual: true
    property :country, virtual: true
    property :zipcode, virtual: true
    property :phone, virtual: true
    property :existing_customer, virtual: true
    property :adj_amount, virtual: true
    property :adj_description, virtual: true

    def products
      Spree::Product.where(id: Spree::Variant.where('deleted_at is NULL').pluck('DISTINCT product_id'))
    end

    def countries
      order_cond = "iso!='US', iso!='CA', iso!='DE', iso!='MX', iso!='GB', iso!='AU', iso!='NZ', name"
      Spree::Country.select([:id, :name]).order(order_cond).map {|c| [c.id, c.name]}
    end

    def countries_with_states
      country_ids = Spree::State.uniq(:country_id).pluck(:country_id)
      Spree::Country.where(id: country_ids).includes(:states)
        .to_json(include:{states: {only: [:id,:name]}}, only: [:id, :name])
    end

    def customers
      user_ids = Spree::Order.complete.select('DISTINCT user_id').limit(10).pluck(:user_id)
      Spree::User.where(id: user_ids).limit(10).map {|u| [u.id, u.full_name]}
    end

    def site_version_options
      {
        'USD' =>'USA',
        'AUD' => 'Australia'
      }
    end

    def skirt_length_options
      Hash[LineItemPersonalization::HEIGHTS.map{|h| [h, h.humanize]}]
    end

    def save_order(params)
      variant = get_variant(params[:style_name], params[:size], params[:color])
      Operations::ManualOrder.new(params, variant).create
    end

  end
end
