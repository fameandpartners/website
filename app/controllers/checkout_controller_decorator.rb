Spree::CheckoutController.class_eval do
  before_filter :prepare_order, only: :edit
  skip_before_filter :check_registration

  def update_registration
    fire_event("spree.user.signup", :order => current_order)

    @user = Spree::User.new(params[:user])
    if @user.save
      current_order.user = @user
      current_order.email = @user.email
      current_order.save

      render 'spree/checkout/registration/success'
    else
      render 'spree/checkout/registration/failed'
    end
  end

  # don't redirect from /edit to separate states
  # we have them all in one place
  def skip_state_validation?
    true
  end

  def edit
    @user = Spree::User.new unless signed_in?
  end

  private

  # run callback - preparations to order states
  def prepare_order
    before_address
  end
end
