class LandingPage::ProductPageView
	atrr_reader :page, :products

  def initialize(page, products)
    @page, @products = page, products
  end

end