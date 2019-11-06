Spree::CheckoutController.class_eval do

  before_filter :before_masterpass
  skip_before_filter :check_registration
  #before_filter :confirm_quad_pay, only: [:update]
  before_filter def switch_views_version
    prepend_view_path Rails.root.join('app/views/checkout/v1')
  end

  after_filter :update_adjustments, only: [:update]

  layout 'redesign/checkout'

  CARD_TYPE_MAPPING = {
    'visa' => 'visa',
    'mastercard' => 'master',
    'american express' => 'american_express',
    'discover' => 'discover',
    'diners club' => 'diners_club'
  }

  def edit
    puts "edit: " + session[:order_id]&.to_s
    prepare_order
    find_payment_methods
    update_line_item_delivery

    unless signed_in?
      @user = Spree::User.new(
        email:      @order.email,
        first_name: @order.user_first_name,
        last_name:  @order.user_last_name
      )
    end

    current_order.updater.update_totals
    respond_with(@order) do |format|
      format.js { render 'spree/checkout/update/success' }
      format.html { render 'edit' }
    end
  end

  # update - address/payment
  def update
    set_order_site_version
    puts "UUUUUUUUUUUU after set_order_site_version"
    find_payment_methods
    puts "UUUUUUUUUUUU after find_payment_methods"
    move_order_from_cart_state(@order)
    puts "UUUUUUUUUUUU after move_order_from_cart_state"
    @order.return_type = 'B'

    if @order.state == 'address' || @order.state == 'masterpass'
      # update first/last names, email
      puts "UUUUUUUUUUUU if order.state == address "
      registration = Services::UpdateUserRegistrationForOrder.new(@order, try_spree_current_user, params.merge( {form_name: 'checkout' }))
      puts "UUUUUUUUUUUU after registration"

      registration.update
      subscribe(registration.user) if params[:subscribe].present?
      if registration.new_user_created?
        fire_event("spree.user.signup", order: current_order)
        sign_in :spree_user, registration.user
        session[:new_user_created] = true
        puts "UUUUUUUUUUUU registration.new_user_created?"
        puts "UUUUUUUUUUUU session[:new_user_created]#{session[:new_user_created]}"
      end
      if !registration.successfull?
        @order.state = 'masterpass' if params[:state] == 'masterpass'
        respond_with(@order) do |format|
          format.html { render :edit }
          format.js   { render 'spree/checkout/registration/failed' }
        end
        puts "UUUUUUUUUUUU registration.successfull?"
        puts "UUUUUUUUUUUU @order.state#{@order.state}"
        puts "UUUUUUUUUUUU params[:state]#{params[:state]}"
        return
      end
      remove_ineligible_promotions
      @order.reload
      puts "UUUUUUUUUUUU  @order.state == 'address' || @order.state == 'masterpass'"
    end

    if @order.update_attributes(object_params)
      puts "UUUUUUUUUUUU after @order.update_attributes(object_params)"
      fire_event('spree.checkout.update')
      puts "UUUUUUUUUUUU  after fire_event"
      if object_params.key?(:coupon_code)
        puts "UUUUUUUUUUUU  object_params.key"
        if object_params[:coupon_code].present? && apply_coupon_code
          puts "UUUUUUUUUUUU  object_params[:coupon_code].present?#{object_params[:coupon_code].present?}"
          @order.reload

          respond_with(@order) do |format|
            format.js{ render 'spree/checkout/coupon_code/success' }
            puts "UUUUUUUUUUUU reder success js"
          end
        else
          respond_with(@order) do |format|
            format.js{ render 'spree/checkout/coupon_code/failure' }
            puts "UUUUUUUUUUUU reder failure js"
          end
        end

        return
      end

      if @credit_card_gateway.type == "Spree::Gateway::Pin"
        puts "UUUUUUUUUUUU after @credit_card_gateway"
        if @order.line_items.length < 1
            render status: 402, json: {
            :message => 'StaleCart'
          }
          return
        end
        #take this path for pin, this code only survives while we transistion to stripe
        if @order.next
          state_callback(:after)
        else
          flash[:error] = t(:payment_processing_failed)
          @order.state = 'masterpass' if params[:state] == 'masterpass'
          respond_with(@order) do |format|
            puts "UUUUUUUUUUUU render @order.state masterpass"
            format.html{ redirect_to checkout_state_path(@order.state) }
            format.js{ render 'spree/checkout/update/failed' }
          end
          return
        end
      else

        if @order.line_items.length < 1
            render status: 402, json: {
            :message => 'StaleCart'
          }
            puts "UUUUUUUUUUUU @order.line_items.length#{@order.line_items.length}"
          return
        end
        #go here for stripeypay
        if @order.next
          state_callback(:after)
          puts "UUUUUUUUUUUU after @order.next"
        else
          render status: 402, json: {
            :message => @order.errors.full_messages.first
          }
          return
        end
      end
      # with 'cart checkout' by paypal express we can return to fill address
      if @order.state == 'payment' && @order.has_checkout_step?('payment')
        state_callback(:before)
        if @order.next
          state_callback(:after)
        else
          @order.errors.delete(:state)
        end
      end
      puts "UUUUUUUUUUUU @order.state#{@order.state}"
      if @order.state == 'complete' || @order.completed?
        GuestCheckoutAssociation.call(spree_order: @order)
        puts "UUUUUUUUUUUU after  GuestCheckoutAssociation"
        @order.vwo_type = params[:return_type] #return type is being hooked into to pass vwo type
        @order.save!
        flash.notice = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special' # necessary for GA conversion tracking

        session[:successfully_ordered] = true
        puts "UUUUUUUUUUUU flash" + flash&.to_s
        # clear masterpass data
        if !session[:masterpass_data].blank?
          session[:masterpass_data] = nil
          flash[:commerce_tracking] = 'masterpass_ordered'
        end

        OrderBotWorker.perform_async(@order.id)
        puts "UUUUUUUUUUUU after OrderBotWorker"
        # Klaviyo placed order
        order_line_items = @order.line_items || []
        @klaviyo = Klaviyo::Client.new(configatron.klaviyo_token)
        @klaviyo.track('Placed Order',
          email: try_spree_current_user&.email || @order.email,
          properties: {
            "$event_id": @order.id,
            "$value": @order.total,
            "ItemNames": order_line_items.map { |line_item| line_item.product.name },
            "Items": order_line_items.map do |line_item|
              {
                "ProductID": line_item.product.id,
                "SKU": line_item.product.sku,
                "ProductName": line_item.product.name,
                "Quantity": line_item.quantity,
                "ItemPrice": line_item.price,
                "RowTotal": line_item.price * line_item.quantity
              }
            end
          },
          time: Time.now
        )
        puts "UUUUUUUUUUUU after  Klaviyo::Client.new"
        order_line_items.each do |line_item|
          @klaviyo.track('Ordered Product',
            email: try_spree_current_user&.email || @order.email,
            properties: {
              "$event_id": line_item.id,
              "$value": line_item.price * line_item.quantity,
              "ProductID": line_item.product.id,
              "SKU": line_item.product.sku,
              "ProductName": line_item.product.name,
              "Quantity": line_item.quantity,
            },
            time: Time.now
          )
        end

        respond_with(@order) do |format|
          format.html{ redirect_to completion_route }
          format.js{ render 'spree/checkout/complete' }
          puts "UUUUUUUUUUUU render js complete"
        end
      else
        # Handle the payment failures, such as 'invalid', 'insufficient Funds', 'declined'
        puts "UUUUUUUUUUUU  @order.state1" +  @order.state
        @order.state = 'masterpass' if params[:state] == 'masterpass'
        respond_with(@order) do |format|
          format.html{ redirect_to checkout_state_path(@order.state) }
          format.js{ render 'spree/checkout/update/failed' }
        end
      end

    else
      @order.state = 'masterpass' if params[:state] == 'masterpass'
      puts "UUUUUUUUUUUU  @order.state2" +  @order.state
      respond_with(@order) do |format|
        format.html { render :edit }
        format.js { render 'spree/checkout/update/failed' }
      end
    end
  end

  # don't redirect from /edit to separate states
  # we have them all in one place
  def skip_state_validation?
    true
  end

  def raise_insufficient_quantity
    flash[:error] = t(:spree_inventory_error_flash_for_insufficient_quantity)
    redirect_to main_app.dresses_path
  end

  def load_order
    @order = current_order

    guard = []

    if @order.present?
      unless @order.checkout_allowed?
        guard << :no_checkout_allowed
      end

      if @order.insufficient_stock_lines.present?
        flash[:error] = t(:spree_inventory_error_flash_for_insufficient_quantity)
        guard << :insufficient_stock_lines
      end

      if @order.completed?
        guard << :order_completed
      end
    else
      guard << :order_is_nil
    end

    unless guard.empty?
      Rails.logger.warn "CheckoutRedirection #{guard.join(', ')}"
      NewRelic::Agent.notify('CheckoutRedirection', order_number: @order.try(:number), guards: guard)

      redirect_to main_app.dresses_path
      return
    end
    # redirect_to main_app.dresses_path and return unless @order and @order.checkout_allowed?
    # raise_insufficient_quantity and return if @order.insufficient_stock_lines.present?
    # redirect_to main_app.dresses_path and return if @order.completed?

    if params[:state]
      redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      @order.state = params[:state]
    end
    state_callback(:before)

    append_gtm_order
    append_gtm_cart_event
  end

  # current_ability.authorize!(*args)
  # Spree::Ability.new(user).authorize!(:edit, order, token)
  def check_authorization
    authorize!(:edit, current_order, session[:access_token])
  end

  def before_address
    @order.bill_address ||= build_default_address
    @order.ship_address ||= build_default_address
  end

  #add from quadpay master

  private
  def object_params
    # For payment step, filter order parameters to produce the expected nested attributes for a single payment and its source, discarding attributes for payment methods other than the one selected
    if (@order.has_checkout_step?("payment") && @order.payment?) || (params[:state] == "masterpass" && @order.has_checkout_step?("address"))
      if params[:payment_source].present? && source_params = params.delete(:payment_source)[params[:order][:payments_attributes].first[:payment_method_id].underscore]
        params[:order][:payments_attributes].first[:source_attributes] = source_params
      end
      if (params[:order][:payments_attributes])
        params[:order][:payments_attributes].first[:amount] = @order.total
      end
    end

    retval = params[:order].except(:password, :password_confirmation)

    #need to map stripe cc_types to accepted accepted activemerchant vals
    if cc_type = retval["payments_attributes"].try(:[], 0)&.dig("source_attributes", "cc_type")
      retval["payments_attributes"][0]["source_attributes"]["cc_type"] = CARD_TYPE_MAPPING[cc_type]
    end
    retval
  end

  # run callback - preparations to order states
  def prepare_order
    before_address
  end

  def before_masterpass
    if params[:state] != nil && params[:state] != 'masterpass' && @order.state.to_s == 'masterpass'
      @order.state = params[:state]
    end

    if params[:state] == 'masterpass'
      if session[:masterpass_data].blank?
        redirect_to checkout_state_path('address')
        return
      end

      @masterpass_data = session[:masterpass_data].checkout
      @order.email = @masterpass_data[:contact][:emailAddress]
      @order.user_first_name = @masterpass_data[:contact][:firstName]
      @order.user_last_name = @masterpass_data[:contact][:lastName]

      before_address

      # Initialize the bulling details
      @order.bill_address.firstname = @order.user_first_name
      @order.bill_address.lastname = @order.user_last_name
      @order.bill_address.email = @order.email
      @order.bill_address.address1 = @masterpass_data[:card][:billingAddress][:line1]
      @order.bill_address.address2 = @masterpass_data[:card][:billingAddress][:line2]
      @order.bill_address.city = @masterpass_data[:card][:billingAddress][:city]
      @order.bill_address.country = Spree::Country.where("iso=?", @masterpass_data[:card][:billingAddress][:country]).first
      country_id = @order.bill_address.country.id
      state_name = @masterpass_data[:card][:billingAddress][:countrySubdivision].sub(
          @masterpass_data[:card][:billingAddress][:country] + '-', '')
      @order.bill_address.state = Spree::State.where("abbr=? and country_id=?",
                                                     state_name,
                                                     country_id).first
      @order.bill_address.phone = @masterpass_data[:contact][:phoneNumber]
      @order.bill_address.zipcode = @masterpass_data[:card][:billingAddress][:postalCode]

      # Initialize the shipping details
      recipientName = @masterpass_data[:shippingAddress][:recipientName].split(' ', 2)
      @order.ship_address.firstname = recipientName[0]
      @order.ship_address.lastname = recipientName[1]
      @order.ship_address.email = @masterpass_data[:contact][:emailAddress]
      @order.ship_address.address1 = @masterpass_data[:shippingAddress][:line1]
      @order.ship_address.address2 = @masterpass_data[:shippingAddress][:line2]
      @order.ship_address.city = @masterpass_data[:shippingAddress][:city]
      @order.ship_address.country = Spree::Country.where("iso=?", @masterpass_data[:shippingAddress][:country]).first
      country_id = @order.ship_address.country.id
      state_name = @masterpass_data[:shippingAddress][:countrySubdivision].sub(
          @masterpass_data[:shippingAddress][:country] + '-', '')
      @order.ship_address.state = Spree::State.where("abbr=? and country_id=?",
                                                     state_name,
                                                     country_id).first
      @order.ship_address.phone = @masterpass_data[:shippingAddress][:recipientPhoneNumber]
      @order.ship_address.zipcode = @masterpass_data[:shippingAddress][:postalCode]
    end
  end

  def country_code_from_ip
    FindCountryFromIP.new(request.remote_ip).country_code
  end

  def build_default_address
    address = Spree::Address.default(current_site_version, country_code_from_ip)

    if (user = try_spree_current_user).present?
      address.firstname ||= user.first_name
      address.lastname ||= user.last_name
      address.email ||= user.email
    end

    if @order.present?
      address.firstname ||= @order.user_first_name
      address.lastname ||= @order.user_last_name
      address.email ||= @order.email
    end
    address.set_last(user, @order)

    address
  end

  # after user submitted some shipping/biliing/payment data
  # order should not be in cart state
  def move_order_from_cart_state(order)
    if order.state == 'cart'
      order.next
      state_callback(:after)
    end
  end

  def remove_ineligible_promotions
     duplicate = @order.adjustments.select {|x| !x.eligible}
     if !duplicate.empty?
       @order.adjustments.promotion.delete(duplicate.first)
       @order.adjustments.delete(duplicate.first)
       @order.save!
     end
  end

  def find_payment_methods
    @credit_card_gateway = Payments::CreditCardLocalizer.new(@order, current_site_version.currency).gateway

    @pay_pal_method = Payments::PaypalLocalizer.new(@order, current_site_version.currency).gateway

    @afterpay_method = @order.available_payment_methods.detect do |method|
      method.method_type == 'afterpay' && current_site_version.currency == method.currency
    end
    @quad_pay_method = @order.available_payment_methods.detect do |method|
      method.method_type == 'quadpay' && current_site_version.currency == method.currency
    end
  end

  helper_method :completion_route

  def set_order_site_version
    @order.site_version = current_site_version.code
  end

  def current_step
    return nil if @order.blank?
    return @current_step if @current_step.present?

    @current_step = @order.state.to_s
    @current_step = 'address' if @current_step.eql?('cart')
    @current_step = 'masterpass' if params[:state] == 'masterpass' && (@current_step.eql?('address') || @current_step.eql?('payment'))
    @current_step
  end
  helper_method :current_step

  def update_adjustments
    @order.create_tax_charge!
    @order.updater.update_adjustments
  end

  # Marketing + GTM

  def gtm_page_type
    'checkout'
  end

  def append_gtm_order
    gtm_order = Marketing::Gtm::Presenter::Order.new(spree_order: @order, base_url: root_url)
    @gtm_container.append(gtm_order)
  end

  def append_gtm_cart_event
    unless @order.state == 'complete'
      gtm_event = Marketing::Gtm::Presenter::Event.new(event_name: 'order_in_progress')
      @gtm_container.append(gtm_event)
    end
  end

  def update_line_item_delivery
    if @order.updated_at < 12.hours.ago #refresh delivery dates every 12 hours in case the china flag is flipped in the last 12 hrs
      @order.line_items.each do |item|
        item.delivery_date = item.delivery_period_policy.delivery_period
        item.save!
      end
    end
  end

  def subscribe(user)
    # disable because we're moving to klaviyo from bronto
    KlaviyoService.new({},
                     email: user.email,
                     newsletter: user.newsletter,
                     first_name: user.first_name,
                     last_name: user.last_name,
                     current_sign_in_ip: request.remote_ip,
                     landing_page: session[:landing_page],
                     utm_params: session[:utm_params],
                     site_version: current_site_version.name,
                     form_name: 'checkout').subscribe_list
  end
end
