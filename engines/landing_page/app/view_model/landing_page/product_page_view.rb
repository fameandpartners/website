class LandingPage::ProductPageView
	attr_reader :page, :products

  delegate :title, :to => :page
  
  def initialize(page, products)
    @page, @products = page, products
  end

end