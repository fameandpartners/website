Spree::Admin::ProductsController.class_eval do
  before_filter :set_default_prototype, :only => [:new]

  protected

  def set_default_prototype
    @prototype = Spree::Product.default_prototype
  end

  def create_before
    set_default_prototype
  end
end