class LandingPage::ProductPresenter
	attr_reader :product
  
  delegate :name, :to => :product

  def initialize(product)
    @product = OpenStruct.new(product)
  end

end