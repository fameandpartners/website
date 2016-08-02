Spree::CheckoutController.class_eval do
  include Marketing::Gtm::Controller::Order
  include Marketing::Gtm::Controller::Product
  include Marketing::Gtm::Controller::Variant
  include Marketing::Gtm::Controller::Event

  before_filter :prepare_order, only: :edit
  before_filter :set_order_site_version, :only => :update
  before_filter :find_payment_methods, only: [:edit, :update]
  before_filter :before_masterpass
  before_filter :data_layer_add_to_cart_event, only: [:edit]
  skip_before_filter :check_registration

  before_filter def switch_views_version
    prepend_view_path Rails.root.join('app/views/checkout/v1')
  end

  after_filter :update_adjustments, only: [:update]

  layout 'redesign/checkout'

  # update - address/payment
  def update
    move_order_from_cart_state(@order)

    if @order.state == 'address' || @order.state == 'masterpass'
      # update first/last names, email
      registration = Services::UpdateUserRegistrationForOrder.new(@order, try_spree_current_user, params)
      registration.update
      if registration.new_user_created?
        fire_event("spree.user.signup", order: current_order)
        sign_in :spree_user, registration.user
        session[:new_user_created] = true
      end
      if !registration.successfull?
        @order.state = 'masterpass' if params[:state] == 'masterpass'
        respond_with(@order) do |format|
          format.html { render :edit }
          format.js   { render 'spree/checkout/registration/failed' }
        end
        return
      end
    end

    if @order.update_attributes(object_params)
      fire_event('spree.checkout.update')
      if object_params.key?(:coupon_code)
        if object_params[:coupon_code].present? && apply_coupon_code
          @order.reload

          respond_with(@order) do |format|
            format.js{ render 'spree/checkout/coupon_code/success' }
          end
        else
          respond_with(@order) do |format|
            format.js{ render 'spree/checkout/coupon_code/failure' }
          end
        end

        return
      end

      if @order.next
        state_callback(:after)
      else
        flash[:error] = t(:payment_processing_failed)
        @order.state = 'masterpass' if params[:state] == 'masterpass'
        respond_with(@order) do |format|
          format.html{ redirect_to checkout_state_path(@order.state) }
          format.js{ render 'spree/checkout/update/failed' }
        end
        return
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

      if @order.state == 'complete' || @order.completed?
        GuestCheckoutAssociation.associate_user_for_guest_checkout(spree_order: @order, spree_current_user: spree_current_user)
        flash.notice = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'

        session[:successfully_ordered] = true

        # clear masterpass data
        if !session[:masterpass_data].blank?
          session[:masterpass_data] = nil
          flash[:commerce_tracking] = 'masterpass_ordered'
        end

        respond_with(@order) do |format|
          format.html{ redirect_to completion_route }
          format.js{ render 'spree/checkout/complete' }
        end
      else
        # Handle the payment failures, such as 'invalid', 'insufficient Funds', 'declined'
        @order.state = 'masterpass' if params[:state] == 'masterpass'
        respond_with(@order) do |format|
          format.html{ redirect_to checkout_state_path(@order.state) }
          format.js{ render 'spree/checkout/update/failed' }
        end
      end

    else
      @order.state = 'masterpass' if params[:state] == 'masterpass'
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
  end

  # current_ability.authorize!(*args)
  # Spree::Ability.new(user).authorize!(:edit, order, token)
  def check_authorization
    authorize!(:edit, current_order, session[:access_token])
  end

  def edit
    unless signed_in?
      @user = Spree::User.new(
        email: @order.email,
        first_name: @order.user_first_name,
        last_name: @order.user_last_name
      )
    end

    respond_with(@order) do |format|
      format.js { render 'spree/checkout/update/success' }
      format.html{ render 'edit' }
      #format.html{ render 'markup_edit' }
    end
  end

  def before_address
    @order.bill_address ||= build_default_address
    @order.ship_address ||= build_default_address
  end

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
    params[:order].except(:password, :password_confirmation)
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

  def build_default_address
    address = Spree::Address.default(current_site_version, session[:country_code])

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

  def find_payment_methods
    @credit_card_gateway = CreditCardGatewayService.new(@order, current_site_version.currency).gateway

    @pay_pal_method = @order.available_payment_methods.detect do |method|
      method.method_type.eql?('paypalexpress') || method.type == 'Spree::Gateway::PayPalExpress'
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
    current_order.updater.update_adjustments
  end

  # Marketing + GTM

  def data_layer_add_to_cart_event
    if (variant_id = flash[:variant_id_added_to_cart])
      # TODO: this conditional should never exist! This should be handled on the PDP page, and send a null value if there's no variant_id (or ever associate a variant_id_dress)
      return if variant_id == 'NaN'

      variant           = Spree::Variant.find(variant_id)
      product_presenter = variant.product.presenter_as_details_resource(current_site_version)

      append_gtm_event(event_name: 'addToCart')
      append_gtm_product(product_presenter: product_presenter)
      append_gtm_variant(spree_variant: variant)
      append_gtm_order(spree_order: current_order)
    end
  end

  def gtm_page_type
    'checkout'
  end
end
