class UserCart::DetailsController < UserCart::BaseController
  respond_to :html, :json, :js
  before_filter :set_user_cart

  def order_delivery_date
    exist_express_making = @user_cart.products.any?{ |p| p.making_options.any?{|mo| mo.name=='Express Making'}}
    all_express_making   = @user_cart.products.all?{ |p| p.making_options.any?{|mo| mo.name=='Express Making'}}

    if all_express_making || !exist_express_making
      max = 0
      @user_cart.products.each do |p|
        date_num = Policies::ProjectDeliveryDatePolicy.new(p).delivery_date
        date_num = date_num[:days_for_making] + date_num[:days_for_delivery] + configatron.days_delivery_emergency
        max = date_num if date_num > max
      end
      date = (Date.today + max).strftime("%d %B")
      render json: {date: date}
      return
    end

    if exist_express_making
      max_express     = 0
      max_non_express = 0
      @user_cart.products.each do |p|
        date_num = Policies::ProjectDeliveryDatePolicy.new(p).delivery_date
        date_num = date_num[:days_for_making] + date_num[:days_for_delivery] + configatron.days_delivery_emergency
        if p.making_options.any?{|mo| mo.name == 'Express Making'}
          max_express = date_num if date_num > max_express
        else
          max_non_express = date_num if date_num > max_non_express
        end
      end
      date_express     = (Date.today + max_express).strftime("%d %B")
      date_non_express = (Date.today + max_non_express).strftime("%d %B")
      render json: {date_express: date_express, date_non_express: date_non_express}
    end
  end

  def show
    check_authorization

    #title('Your Shopping Cart', default_seo_title)

    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   {
        render json: @user_cart.serialize, status: :ok
      }
    end
  end

  def set_user_cart
    @user_cart = user_cart_resource.read
  end
end
