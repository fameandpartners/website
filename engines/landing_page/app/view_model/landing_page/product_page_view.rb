class LandingPage::ProductPageView
	attr_reader :page, :filter

  delegate :title, :to => :page
  
  def initialize(page, filter)
    @page, @filter = page, filter
  end

  def products
    filter.color_variants
  end
  
end