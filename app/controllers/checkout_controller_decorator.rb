Spree::CheckoutController.class_eval do
  before_filter :prepare_order, only: :edit

  # don't redirect from /edit to separate states
  # we have them all in one place
  def skip_state_validation?
    true
  end

  private

  # run callback - preparations to order states
  def prepare_order
    before_address
  end
end
